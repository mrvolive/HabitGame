//
//  PointsHistoryView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI
import Charts // Importation du framework Charts pour l'affichage graphique

/// Une sous-vue privée responsable de l'affichage du graphique à barres de l'historique des points.
///
/// Cette vue encapsule la configuration et la logique d'affichage du `Chart`
/// pour les données de points quotidiens. Elle est conçue pour être utilisée
/// exclusivement par ``PointsHistoryView``.
private struct PointsChartSubView: View {
    /// L'historique des points quotidiens à afficher.
    /// **Important :** Ce tableau doit être trié par date de manière ascendante
    /// (du plus ancien au plus récent) pour un affichage et un défilement corrects.
    let history: [DailyPoints]
    
    /// La valeur maximale de points atteinte sur une journée dans l'historique.
    /// Utilisée pour définir l'échelle de l'axe Y du graphique.
    let maxYValue: Int
    
    /// Constante représentant la durée d'une semaine en secondes.
    /// Utilisée pour définir la fenêtre de temps visible initialement dans le graphique.
    let weekInSeconds = 7 * 24 * 60 * 60
    
    /// La date sur laquelle le graphique doit initialement se centrer ou se positionner.
    /// Typiquement, la date la plus récente de l'historique.
    let initialScrollToDate: Date
    
    /// Une fonction de rappel pour formater les dates affichées sur les étiquettes de l'axe X.
    let dateStringFormatter: (Date) -> String

    /// Le corps de la vue, construisant le graphique à barres.
    ///
    /// Le graphique affiche des `BarMark` pour chaque entrée de `history`,
    /// avec la date sur l'axe X et les points sur l'axe Y.
    /// Il inclut une personnalisation de l'axe X pour afficher les dates formatées,
    /// un défilement horizontal, une fenêtre visible initiale d'une semaine,
    /// et un positionnement initial sur `initialScrollToDate`.
    var body: some View {
        Chart {
            ForEach(history, id: \.date) { entry in
                BarMark(
                    x: .value("Date", entry.date, unit: .day), // Utilise Date directement pour l'axe X, avec une unité journalière.
                    y: .value("Points", entry.points)
                )
            }
        }
        .chartXAxis { // Personnalise l'apparence de l'axe X.
            AxisMarks(values: .stride(by: .day)) { value in // Crée des marques pour chaque jour.
                AxisGridLine() // Ligne de grille verticale.
                AxisTick()     // Petite coche sur l'axe.
                if let date = value.as(Date.self) { // Récupère la date pour la marque.
                    AxisValueLabel(dateStringFormatter(date)) // Affiche la date formatée.
                }
            }
        }
        .foregroundStyle(Color.blue) // Couleur des barres du graphique.
        .chartYScale(domain: 0...(maxYValue > 0 ? maxYValue : 1)) // Définit l'échelle de l'axe Y, avec un minimum de 1 si maxYValue est 0.
        .chartScrollableAxes(.horizontal) // Permet le défilement horizontal du graphique.
        .chartXVisibleDomain(length: weekInSeconds) // Définit la portion de l'axe X visible initialement (environ 7 jours).
        // Positionne la vue initiale du graphique pour que `initialScrollToDate` soit visible.
        // Note: `hashValue` est utilisé ici comme proxy pour une position. Un ID plus stable basé sur la date pourrait être envisagé si `hashValue` cause des problèmes.
        .chartScrollPosition(initialX: initialScrollToDate.hashValue - weekInSeconds)
        .padding()
        .frame(height: 300) // Hauteur fixe pour le graphique.
    }
}

/// Une vue SwiftUI qui affiche l'historique des points gagnés par l'utilisateur sous forme de graphique à barres.
///
/// Cette vue utilise le framework `Charts` pour visualiser les points accumulés par date.
/// Le graphique est défilable horizontalement. Si aucun historique n'est disponible, un message l'indique.
/// L'axe Y du graphique s'adapte dynamiquement au nombre maximal de points gagnés sur une journée.
/// La vue utilise une sous-vue privée, ``PointsChartSubView``, pour l'affichage du graphique.
struct PointsHistoryView: View {
    /// L'instance de ``AppData`` injectée depuis l'environnement.
    ///
    /// Elle fournit l'accès à `pointHistory`, qui contient les données des points quotidiens
    /// de l'utilisateur.
    @EnvironmentObject var appData: AppData

    /// Le corps de la vue, qui construit l'interface utilisateur de l'historique des points.
    ///
    /// Il affiche un titre, puis soit un message indiquant l'absence d'historique,
    /// soit le graphique des points (via ``PointsChartSubView``) si des données existent.
    /// Les données de l'historique sont triées chronologiquement avant d'être passées au graphique.
    var body: some View {
        NavigationView {
            VStack {
                Text("Points Gagnés")
                    .font(.headline)
                    .padding(.top)

                if appData.pointHistory.isEmpty {
                    Text("Aucun historique de points pour le moment.")
                        .padding()
                    Spacer() // Pousse le texte vers le haut s'il n'y a pas de graphique.
                } else {
                    // Trie l'historique par date ascendante (du plus ancien au plus récent).
                    // Ceci est crucial pour le bon fonctionnement du défilement et de la fenêtre visible du graphique.
                    let chronologicalPointHistory = appData.pointHistory.sorted { $0.date < $1.date }

                    // Calcule la valeur Y maximale pour l'échelle du graphique.
                    // Si l'historique est vide (bien que vérifié avant), max() retournerait nil, d'où le `?? 0`.
                    let maxYValue = appData.pointHistory.map(\.points).max() ?? 0
                    
                    // Détermine la date la plus récente dans l'historique pour le positionnement initial du scroll.
                    // `chronologicalPointHistory` ne sera pas vide ici grâce à la vérification `appData.pointHistory.isEmpty` précédente.
                    let mostRecentDateInHistory = chronologicalPointHistory.last!.date

                    // Utilisation de la sous-vue pour afficher le graphique.
                    PointsChartSubView(
                        history: chronologicalPointHistory,
                        maxYValue: maxYValue,
                        initialScrollToDate: mostRecentDateInHistory,
                        dateStringFormatter: dateString // Passe la méthode de formatage `dateString` en tant que fonction.
                    )
                    
                    Spacer() // Pousse le graphique vers le haut si la liste n'est pas vide.
                }
            }
            .navigationTitle("Historique des Points")
        }
    }

    /// Formate une `Date` en une chaîne de caractères pour l'affichage sur l'axe X du graphique.
    ///
    /// - Si la date est aujourd'hui, retourne "Auj.".
    /// - Si la date est hier, retourne "Hier".
    /// - Sinon, retourne le jour de la semaine abrégé et le jour du mois (ex: "Lun. 15").
    ///
    /// - Parameter date: La `Date` à formater.
    /// - Returns: Une chaîne de caractères représentant la date formatée.
    private func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR") // Localisation en français.
        if Calendar.current.isDateInToday(date) { return "Auj." }
        if Calendar.current.isDateInYesterday(date) { return "Hier" }
        dateFormatter.dateFormat = "EEE dd" // Format: Jour abrégé (Lun, Mar, ...) suivi du jour du mois.
        return dateFormatter.string(from: date)
    }
}

/// Fournit un aperçu pour `PointsHistoryView` dans Xcode Previews.
struct PointsHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        return PointsHistoryView().environmentObject(AppData())
    }
}
