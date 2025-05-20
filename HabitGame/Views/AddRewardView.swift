//
//  AddRewardView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI

struct AddRewardView: View {
    @EnvironmentObject var appData: AppData
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var costString: String = ""

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (Int(costString) ?? 0) > 0
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails de la récompense")) {
                    TextField("Nom de la récompense (ex: Film)", text: $name)
                    TextField("Coût en points (ex: 100)", text: $costString)
                        .keyboardType(.numberPad)
                }

                Button("Ajouter la récompense") {
                    if let cost = Int(costString) {
                        appData.addReward(name: name.trimmingCharacters(in: .whitespacesAndNewlines), cost: cost)
                        dismiss()
                    }
                }
                .disabled(!canSave)
            }
            .navigationTitle("Nouvelle Récompense")
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

struct AddRewardView_Previews: PreviewProvider {
    static var previews: some View {
        AddRewardView().environmentObject(AppData())
    }
}
