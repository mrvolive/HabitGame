//
//  AddHabitView.swift
//  HabitGame
//
//  Created by VotreNom (ou maraval olivier) le 20/05/2025.
//

import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var appData: AppData
    @Environment(\.dismiss) var dismiss // Pour fermer la vue modale

    @State private var name: String = ""
    @State private var pointsString: String = "" // Utiliser String pour le TextField

    // Vérifie si le nom n'est pas vide et si les points sont un nombre valide > 0
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (Int(pointsString) ?? 0) > 0
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails de l'habitude")) {
                    TextField("Nom de l'habitude (ex: Lire)", text: $name)
                    TextField("Points (ex: 10)", text: $pointsString)
                        .keyboardType(.numberPad) // Clavier numérique pour les points
                }

                Button("Ajouter l'habitude") {
                    if let points = Int(pointsString) { // Assure que la conversion est réussie
                        appData.addHabit(name: name.trimmingCharacters(in: .whitespacesAndNewlines), points: points)
                        dismiss() // Ferme la vue modale après l'ajout
                    }
                }
                .disabled(!canSave) // Désactive le bouton si les champs ne sont pas valides
            }
            .navigationTitle("Nouvelle Habitude")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        // Fournir un AppData pour la preview
        AddHabitView().environmentObject(AppData())
    }
}
