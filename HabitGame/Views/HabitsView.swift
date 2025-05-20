//
//  HabitsView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI

/// Affiche la liste des habitudes de l'utilisateur et permet de les marquer comme complétées.
///
/// Cette vue utilise une `NavigationView` pour présenter une liste (`List`) des habitudes.
/// Chaque habitude affiche son nom, le nombre de points qu'elle rapporte, et un bouton
/// pour la marquer comme complétée pour la journée.
/// Elle accède aux données de l'application via l'objet d'environnement `AppData`.
/// La vue permet également d'ajouter de nouvelles habitudes et de supprimer celles existantes.
/// Un graphique circulaire en haut de la vue montre le pourcentage global de complétion des habitudes.
struct HabitsView: View {
    /// L'instance de `AppData` injectée depuis l'environnement, contenant les données des habitudes.
    @EnvironmentObject var appData: AppData
    /// État pour contrôler l'affichage de la feuille modale d'ajout d'habitude.
    @State private var showingAddHabitSheet = false

    /// Calcule le pourcentage d'habitudes complétées aujourd'hui.
    /// Retourne une valeur entre 0.0 et 1.0.
    private var completionPercentage: Double {
        // S'il n'y a pas d'habitudes, le pourcentage de complétion est de 0.
        guard !appData.habits.isEmpty else { return 0.0 }
        
        // Compte le nombre d'habitudes marquées comme complétées aujourd'hui.
        let completedCount = appData.habits.filter { $0.isCompletedToday }.count
        
        // Calcule le pourcentage.
        return Double(completedCount) / Double(appData.habits.count)
    }

    /// Le corps de la vue, définissant la structure de l'interface utilisateur.
    var body: some View {
        NavigationView {
            // VStack principal pour empiler le graphique et la liste
            VStack(spacing: 0) { // spacing: 0 pour coller le graphique à la liste si désiré
                
                // Graphique de complétion circulaire
                CompletionCircleView(progress: completionPercentage, circleColor: .blue, lineWidth: 15, percentageFontSize: .title2)
                    .frame(width: 120, height: 120) // Définir une taille pour le cercle
                    .padding(.vertical, 20) // Ajouter de l'espace vertical autour du cercle
                
                // Liste des habitudes
                List {
                    // Itère sur les habitudes. Le `$` permet la liaison bidirectionnelle si nécessaire
                    // pour des sous-vues qui modifieraient directement 'habit'.
                    ForEach($appData.habits) { $habit in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(habit.name)
                                    .font(.headline)
                                Text("\(habit.points) points")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer() // Pousse le bouton vers la droite
                            Button(action: {
                                // Appelle la méthode pour compléter/dé-compléter l'habitude dans AppData
                                appData.completeHabit(habit: habit)
                            }) {
                                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(habit.isCompletedToday ? .green : .gray)
                                    .imageScale(.large)
                            }
                            .buttonStyle(BorderlessButtonStyle()) // Assure que seul le bouton est interactif
                        }
                    }
                    .onDelete(perform: deleteHabits) // Active la suppression par balayage en mode édition
                }
                // .listStyle(InsetGroupedListStyle()) // Optionnel: pour un style de liste différent si le graphique est très proche
            }
            .navigationTitle("Mes Habitudes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Le bouton Éditer standard de SwiftUI pour activer/désactiver le mode édition de la liste.
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddHabitSheet = true // Ouvre la feuille modale pour ajouter une habitude
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabitSheet) {
                // Présente AddHabitView en feuille modale.
                // Il est crucial de passer l'environmentObject à la vue présentée.
                AddHabitView().environmentObject(appData)
            }
        }
    }

    /// Fonction appelée par le modificateur `.onDelete` de la `List`.
    /// Elle transmet l'action de suppression à l'objet `AppData`.
    private func deleteHabits(at offsets: IndexSet) {
        appData.deleteHabits(at: offsets)
    }
}

/// Fournit un aperçu pour `HabitsView` dans Xcode.
struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        // Crée une instance d'AppData pour la prévisualisation
        let sampleAppData = AppData()
        // Pré-remplir avec quelques habitudes pour un meilleur aperçu du graphique
        sampleAppData.habits = [
            Habit(name: "Faire du sport", points: 20, isCompletedToday: true),
            Habit(name: "Lire un livre", points: 10, isCompletedToday: false),
            Habit(name: "Méditer", points: 15, isCompletedToday: true),
            Habit(name: "Boire de l'eau", points: 5, isCompletedToday: false)
        ]
        return HabitsView().environmentObject(sampleAppData)
    }
}
