//
//  HabitListView.swift
//  HabitGame
//
//  Created by maraval olivier on 07/05/2025.
//

import SwiftUI

struct HabitListView: View {
    @Binding var habits: [HabitsData]
    @Binding var showingAddHabit: Bool
    @State private var habitToEdit: HabitsData?
    @State private var showingEditSheet = false
    
    var body: some View {
        List {
            if habits.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .padding(.top, 40)
                    
                    Text("Aucune habitude pour le moment")
                        .font(.headline)
                    
                    Text("Ajoutez votre première habitude en appuyant sur le bouton ajouter")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button {
                        showingAddHabit = true
                    } label: {
                        Text("Ajouter une habitude")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets())
                .background(Color(UIColor.systemGroupedBackground))
            } else {
                VStack(spacing: 20) {
                    List{
                        ForEach(habits){habit in
                            Text(habit.name)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct HabitRow: View {
    let habit: HabitsData
    let isEditing: Bool
    let onComplete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.name)
                    .font(.headline)
                
                Text("\(habit.value) points")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !isEditing {
                Button {
                    onComplete()
                } label: {
                    Text("Valider")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
