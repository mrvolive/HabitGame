//
//  AddHabitView.swift
//  HabitGame
//
//  Created by maraval olivier on 07/05/2025.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var habits: [HabitsData]
    @State private var habitName = ""
    @State private var habitValue = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails de l'habitude")) {
                    TextField("Nom de l'habitude", text: $habitName)
                    
                    TextField("Points (1-1000)", text: $habitValue)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button("Ajouter l'habitude") {
                        addHabit()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(isFormValid ? .blue : .gray)
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Nouvelle habitude")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
            .alert("Erreur", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Veuillez entrer un nom et une valeur de points valide (1-1000).")
            }
        }
    }
    
    private var isFormValid: Bool {
        !habitName.isEmpty && !habitValue.isEmpty &&
        Int(habitValue) != nil && (Int(habitValue) ?? 0) >= 1 && (Int(habitValue) ?? 0) <= 1000
    }
    
    private func addHabit() {
        guard let value = Int(habitValue), value >= 1, value <= 1000, !habitName.isEmpty else {
            showAlert = true
            return
        }
        
        let newHabit = HabitsData(name: habitName, value: value)
        habits.append(newHabit)
        dismiss()
    }
}
