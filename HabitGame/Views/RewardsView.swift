//
//  RewardsView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI

/// Une vue SwiftUI qui affiche la liste des récompenses disponibles et permet à l'utilisateur de les "acheter" avec ses points accumulés.
///
/// Cette vue présente :
/// - Le solde de points actuel de l'utilisateur.
/// - Une liste (`List`) des récompenses, chacune affichant son nom et son coût en points.
/// - Un bouton "Acheter" pour chaque récompense si l'utilisateur dispose d'assez de points.
/// - La possibilité d'ajouter de nouvelles récompenses via une feuille modale (``AddRewardView``).
/// - La possibilité de supprimer des récompenses existantes en mode édition.
///
/// La vue interagit avec ``AppData`` pour accéder aux données des récompenses, au solde de points
/// et pour effectuer les actions d'achat et de suppression.
struct RewardsView: View {
    /// L'instance partagée de ``AppData`` injectée depuis l'environnement.
    ///
    /// Elle fournit l'accès au solde de points actuel (`currentPoints`), à la liste des
    /// récompenses (`rewards`), et aux méthodes pour acheter (`buyReward(reward:)`)
    /// et supprimer (`deleteRewards(at:)`) des récompenses.
    @EnvironmentObject var appData: AppData
    
    /// Un état booléen qui contrôle la présentation de la feuille modale ``AddRewardView``.
    ///
    /// Lorsque `true`, la feuille modale pour ajouter une nouvelle récompense est affichée.
    @State private var showingAddRewardSheet = false

    /// Le corps de la vue, définissant la structure et l'apparence de l'interface utilisateur.
    ///
    /// Il se compose d'une `NavigationView` contenant :
    /// - Un `VStack` principal affichant le solde de points.
    /// - Une `List` qui itère sur `appData.rewards` pour afficher chaque récompense.
    ///   - Chaque récompense est présentée dans un `HStack` avec son nom, son coût, et
    ///     un bouton "Acheter" (si les points sont suffisants) ou un message "Insuffisant".
    ///   - La liste supporte la suppression d'éléments via le modificateur `.onDelete`.
    /// La barre de navigation (`toolbar`) contient un `EditButton` pour le mode édition et un
    /// bouton "+" pour présenter la feuille d'ajout de récompense (`.sheet`).
    var body: some View {
        NavigationView {
            VStack {
                Text("Mes Points: \(appData.currentPoints)")
                    .font(.title2)
                    .padding()

                List {
                    ForEach(appData.rewards) { reward in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(reward.name)
                                    .font(.headline)
                                Text("\(reward.cost) points")
                                    .font(.subheadline)
                                    .foregroundColor(.orange) // Met en évidence le coût.
                            }
                            Spacer() // Pousse le bouton/texte vers la droite.
                            if appData.currentPoints >= reward.cost {
                                Button("Acheter") {
                                    appData.buyReward(reward: reward) // Appelle la méthode d'achat dans AppData.
                                }
                                .buttonStyle(.borderedProminent) // Style de bouton distinctif.
                                .tint(.green) // Couleur verte pour l'action positive.
                            } else {
                                Text("Insuffisant")
                                    .font(.caption)
                                    .foregroundColor(.red) // Indique clairement le manque de points.
                                    .padding(.horizontal, 10) // Ajoute un espacement pour une meilleure lisibilité.
                            }
                        }
                    }
                    .onDelete(perform: deleteRewards) // Active la suppression par balayage lorsque la liste est en mode édition.
                }
            }
            .navigationTitle("Boutique") // Titre de la vue dans la barre de navigation.
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Bouton standard pour activer/désactiver le mode édition de la liste,
                    // permettant ainsi la suppression d'éléments.
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddRewardSheet = true // Déclenche l'affichage de la feuille modale.
                    }) {
                        Image(systemName: "plus.circle.fill") // Icône standard pour l'ajout.
                            .imageScale(.large) // Rend l'icône légèrement plus grande.
                    }
                }
            }
            .sheet(isPresented: $showingAddRewardSheet) {
                // Présente la vue AddRewardView en tant que feuille modale.
                // L'instance d'AppData est passée à AddRewardView via l'environnement.
                AddRewardView().environmentObject(appData)
            }
        }
    }

    /// Supprime des récompenses de la liste en fonction des `IndexSet` fournis.
    ///
    /// Cette fonction est appelée par le modificateur `.onDelete` appliqué à la `List`.
    /// Elle transmet l'action de suppression à la méthode `deleteRewards(at:)` de l'objet ``AppData``.
    ///
    /// - Parameter offsets: Un `IndexSet` contenant les indices des récompenses à supprimer
    ///   dans la liste `appData.rewards`.
    private func deleteRewards(at offsets: IndexSet) {
        appData.deleteRewards(at: offsets)
    }
}

/// Fournit un aperçu pour `RewardsView` dans Xcode Previews.
///
/// Cette structure permet de visualiser et d'interagir avec `RewardsView`
/// pendant le développement. Une instance de `AppData` (potentiellement avec des données
/// de test pour les récompenses et les points) est injectée dans l'environnement
/// pour que la vue d'aperçu puisse fonctionner et afficher des données pertinentes.
struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAppData = AppData()
        // Décommentez et modifiez ces lignes pour pré-remplir des données pour l'aperçu :
        // sampleAppData.rewards = [
        //     Reward(id: UUID(), name: "Café offert", cost: 50),
        //     Reward(id: UUID(), name: "Pause de 15 min", cost: 25),
        //     Reward(id: UUID(), name: "Cinéma", cost: 200)
        // ]
        // sampleAppData.currentPoints = 100 // Simule un solde de points pour tester l'affichage des boutons "Acheter".
        return RewardsView().environmentObject(sampleAppData)
    }
}
