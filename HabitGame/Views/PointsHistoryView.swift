//
//  PointsHistoryView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI
import Charts // Importation du framework Charts pour l'affichage graphique

// Sous-vue privée pour encapsuler la logique du graphique
private struct PointsChartSubView: View {
    let history: [DailyPoints] // Doit être trié par date ASCENDANTE
    let maxYValue: Int
    let weekInSeconds = 7 * 24 * 60 * 60
    let initialScrollToDate: Date
    let dateStringFormatter: (Date) -> String

    var body: some View {
        Chart {
            ForEach(history, id: \.date) { entry in
                BarMark(
                    x: .value("Date", entry.date, unit: .day), // Utiliser Date directement pour l'axe X
                    y: .value("Points", entry.points)
                )
            }
        }
        .chartXAxis { // Personnalisation des étiquettes de l'axe X
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                if let date = value.as(Date.self) {
                    AxisValueLabel(dateStringFormatter(date))
                }
            }
        }
        .foregroundStyle(Color.blue)
        .chartYScale(domain: 0...(maxYValue > 0 ? maxYValue : 1))
        .chartScrollableAxes(.horizontal) // Activer le défilement horizontal
        .chartXVisibleDomain(length: weekInSeconds) // Fenêtre visible d'environ 7 jours (en secondes)
        .chartScrollPosition(initialX: initialScrollToDate.hashValue - weekInSeconds) // Positionner sur la date la plus récente
        .padding()
        .frame(height: 300)
    }
}

/// Affiche l'historique des points gagnés par l'utilisateur sous forme de graphique à barres.
///
/// Cette vue utilise le framework `Charts` pour visualiser les points accumulés par date.
/// Le graphique est défilable horizontalement. Si aucun historique n'est disponible, un message l'indique.
/// L'axe Y du graphique s'adapte dynamiquement au nombre maximal de points gagnés sur une journée.
struct PointsHistoryView: View {
    /// L'instance de `AppData` injectée depuis l'environnement, contenant l'historique des points.
    @EnvironmentObject var appData: AppData

    var body: some View {
        NavigationView {
            VStack {
                Text("Points Gagnés")
                    .font(.headline)
                    .padding(.top)

                if appData.pointHistory.isEmpty {
                    Text("Aucun historique de points pour le moment.")
                        .padding()
                    Spacer()
                } else {
                    // Trier l'historique par date ascendante (plus ancien au plus récent)
                    // C'est important pour le bon fonctionnement de chartScrollPosition et chartXVisibleDomain
                    let chronologicalPointHistory = appData.pointHistory.sorted { $0.date < $1.date }

                    // Calculer la valeur Y maximale pour l'échelle du graphique
                    let maxYValue = appData.pointHistory.map(\.points).max() ?? 0
                    
                    // Déterminer la date la plus récente pour le positionnement initial du scroll.
                    // chronologicalPointHistory ne sera pas vide ici grâce à la vérification appData.pointHistory.isEmpty.
                    let mostRecentDateInHistory = chronologicalPointHistory.last!.date

                    // Utilisation de la sous-vue pour le graphique
                    PointsChartSubView(
                        history: chronologicalPointHistory,
                        maxYValue: maxYValue,
                        initialScrollToDate: mostRecentDateInHistory,
                        dateStringFormatter: dateString // Passer la méthode de formatage
                    )
                    
                    Spacer() // Pousse le graphique vers le haut si la liste n'est pas vide
                }
            }
            .navigationTitle("Historique des Points")
        }
    }

    /// Formate une `Date` en une chaîne de caractères pour l'affichage sur l'axe X du graphique.
    private func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        if Calendar.current.isDateInToday(date) { return "Auj." }
        if Calendar.current.isDateInYesterday(date) { return "Hier" }
        dateFormatter.dateFormat = "EEE dd"
        return dateFormatter.string(from: date)
    }
}

/// Fournit un aperçu pour `PointsHistoryView` dans Xcode.
struct PointsHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        return PointsHistoryView().environmentObject(AppData())
    }
}
