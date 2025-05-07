//
//  ContentView.swift
//  HabitGame
//
//  Created by maraval olivier on 07/05/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIndex: Int = 0
    @State private var habits = HabitsData.habitsTest
    @State private var showingAddHabit = false
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            // Habits Screen
            NavigationStack {
                HabitListView(habits: $habits, showingAddHabit: $showingAddHabit)
                    .navigationTitle("Habitudes")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                            } label: {
                                Text("Modifier")
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showingAddHabit = true
                            } label: {
                                Text("Ajouter")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddHabit) {
                        AddHabitView(habits: $habits)
                    }
            }
            .tabItem {
                Text("Habitudes")
                Image(systemName: "checkmark.seal")
                    .renderingMode(.template)
            }
            .badge("2")
            .tag(0)
            
            // Reward Screen
            NavigationStack {
                Text("Récompenses")
                    .navigationTitle("Récompenses")
            }
            .tabItem {
                Text("Récompenses")
                Image(systemName: "cart.circle")
            }
            .tag(1)
        
            // History Screen
            NavigationStack {
                Text("Historique")
                    .navigationTitle("Points Gagnés")
            }
            .tabItem {
                Text("Historique")
                Image(systemName: "chart.bar")
            }
            .tag(2)
        }
    }
}
#Preview {
    ContentView()
}
