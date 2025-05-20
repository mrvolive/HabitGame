//
//  RewardsView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI

/// Affiche la liste des récompenses disponibles et permet à l'utilisateur de les acheter avec ses points.
///
/// Cette vue présente le solde de points actuel de l'utilisateur en haut, suivi d'une liste (`List`)
/// des récompenses. Pour chaque récompense, son nom et son coût en points sont affichés.
/// Un bouton "Acheter" est disponible si l'utilisateur a suffisamment de points.
/// Elle permet également d'ajouter et de supprimer des récompenses.
struct RewardsView: View {
    /// L'instance de `AppData` injectée depuis l'environnement.
    @EnvironmentObject var appData: AppData
    /// État pour contrôler l'affichage de la feuille modale d'ajout de récompense.
    @State private var showingAddRewardSheet = false

    /// Le corps de la vue, définissant la structure de l'interface utilisateur.
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
                                    .foregroundColor(.orange)
                            }
                            Spacer()
                            if appData.currentPoints >= reward.cost {
                                Button("Acheter") {
                                    appData.buyReward(reward: reward)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                            } else {
                                Text("Insuffisant")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 10) // Ajoute un peu d'espace pour la lisibilité
                            }
                        }
                    }
                    .onDelete(perform: deleteRewards) // Active la suppression par balayage en mode édition
                }
            }
            .navigationTitle("Boutique")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Bouton Éditer standard pour activer/désactiver le mode édition de la liste.
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddRewardSheet = true // Ouvre la feuille modale pour ajouter une récompense
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingAddRewardSheet) {
                // Présente AddRewardView en feuille modale.
                AddRewardView().environmentObject(appData)
            }
        }
    }

    /// Fonction appelée par le modificateur `.onDelete` de la `List`.
    /// Elle transmet l'action de suppression à l'objet `AppData`.
    private func deleteRewards(at offsets: IndexSet) {
        appData.deleteRewards(at: offsets)
    }
}

struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAppData = AppData()
        // Vous pouvez pré-remplir sampleAppData.rewards pour l'aperçu
        // sampleAppData.rewards = [
        //     Reward(name: "Récompense Exemple 1", cost: 25),
        //     Reward(name: "Récompense Exemple 2", cost: 75)
        // ]
        // sampleAppData.currentPoints = 100 // Pour tester l'affichage du bouton "Acheter"
        return RewardsView().environmentObject(sampleAppData)
    }
}
