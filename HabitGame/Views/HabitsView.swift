//
//  HabitsView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI

/// Affiche la liste des habitudes de l'utilisateur, permet de les marquer comme complétées,
/// et visualise la progression globale via un graphique circulaire.
///
/// Cette vue utilise une `NavigationView` pour présenter :
/// - Un graphique circulaire (``CompletionCircleView``) en haut, montrant le pourcentage
///   d'habitudes complétées pour la journée en cours.
/// - Une liste (`List`) des habitudes de l'utilisateur. Chaque élément de la liste affiche
///   le nom de l'habitude, les points qu'elle rapporte, et un bouton pour la marquer
///   comme complétée ou non pour la journée.
///
/// La vue interagit avec l'objet d'environnement ``AppData`` pour accéder aux données des habitudes
/// et pour effectuer des actions telles que compléter une habitude ou en supprimer.
/// Elle permet également d'ajouter de nouvelles habitudes via une feuille modale (``AddHabitView``)
/// et de supprimer des habitudes existantes en utilisant le mode édition de la liste.
struct HabitsView: View {
    /// L'instance partagée de ``AppData`` injectée depuis l'environnement.
    ///
    /// Elle fournit l'accès à la liste des habitudes (`habits`), aux méthodes pour
    /// compléter une habitude (`completeHabit(habit:)`), et pour supprimer
    /// des habitudes (`deleteHabits(at:)`).
    @EnvironmentObject var appData: AppData
    
    /// Un état booléen qui contrôle la présentation de la feuille modale ``AddHabitView``.
    ///
    /// Lorsque `true`, la feuille modale pour ajouter une nouvelle habitude est affichée.
    @State private var showingAddHabitSheet = false

    /// Calcule le pourcentage d'habitudes marquées comme complétées pour la journée en cours.
    ///
    /// Si aucune habitude n'est définie, le pourcentage retourné est de 0.0.
    /// Sinon, il est calculé comme le nombre d'habitudes complétées aujourd'hui
    /// divisé par le nombre total d'habitudes.
    ///
    /// - Returns: Un `Double` représentant le pourcentage de complétion (entre 0.0 et 1.0).
    private var completionPercentage: Double {
        // S'il n'y a pas d'habitudes, le pourcentage de complétion est de 0.
        guard !appData.habits.isEmpty else { return 0.0 }
        
        // Compte le nombre d'habitudes marquées comme complétées aujourd'hui.
        let completedCount = appData.habits.filter { $0.isCompletedToday }.count
        
        // Calcule et retourne le pourcentage.
        return Double(completedCount) / Double(appData.habits.count)
    }

    /// Le corps de la vue, définissant la structure et l'apparence de l'interface utilisateur.
    ///
    /// Il se compose d'une `NavigationView` contenant un `VStack` principal.
    /// Le `VStack` empile :
    ///   - Une instance de ``CompletionCircleView`` affichant `completionPercentage`.
    ///   - Une `List` qui itère sur `$appData.habits` pour afficher chaque habitude.
    ///     - Chaque habitude est présentée dans un `HStack` avec son nom, ses points,
    ///       et un bouton pour la marquer comme complétée/non complétée.
    ///     - La liste supporte la suppression d'éléments via le modificateur `.onDelete`.
    /// La barre de navigation (`toolbar`) contient un `EditButton` pour le mode édition
    /// et un bouton "+" pour présenter la feuille d'ajout d'habitude (`.sheet`).
    var body: some View {
        NavigationView {
            // VStack principal pour empiler le graphique et la liste.
            // `spacing: 0` peut être utilisé pour minimiser l'espace entre le graphique et la liste.
            VStack(spacing: 0) {
                
                // Graphique de complétion circulaire.
                // `progress` est lié à la propriété calculée `completionPercentage`.
                CompletionCircleView(progress: completionPercentage, circleColor: .blue, lineWidth: 15, percentageFontSize: .title2)
                    .frame(width: 120, height: 120) // Définit une taille fixe pour le cercle.
                    .padding(.vertical, 20) // Ajoute un espacement vertical autour du cercle.
                
                // Liste des habitudes.
                List {
                    // Itère sur les habitudes. L'utilisation de `$` devant `appData.habits`
                    // et `habit` permet une liaison bidirectionnelle, ce qui est utile si
                    // des sous-vues devaient modifier directement l'état de `habit`.
                    ForEach($appData.habits) { $habit in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(habit.name)
                                    .font(.headline)
                                Text("\(habit.points) points")
                                    .font(.subheadline)
                                    .foregroundColor(.gray) // Couleur discrète pour les points.
                            }
                            Spacer() // Pousse le bouton vers la droite.
                            Button(action: {
                                // Appelle la méthode pour compléter ou dé-compléter l'habitude dans AppData.
                                appData.completeHabit(habit: habit)
                            }) {
                                // L'icône change en fonction de l'état de complétion de l'habitude.
                                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(habit.isCompletedToday ? .green : .gray) // Vert si complétée, gris sinon.
                                    .imageScale(.large) // Rend l'icône plus visible.
                            }
                            // Empêche le bouton d'affecter l'interaction de toute la cellule de la liste.
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    // Active la suppression par balayage lorsque la liste est en mode édition.
                    .onDelete(perform: deleteHabits)
                }
                // `.listStyle(InsetGroupedListStyle())` peut être utilisé pour un style de liste différent,
                // particulièrement si le graphique est très proche et que l'on souhaite une séparation visuelle.
            }
            .navigationTitle("Mes Habitudes") // Titre de la vue dans la barre de navigation.
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Bouton standard de SwiftUI pour activer/désactiver le mode édition de la liste,
                    // permettant ainsi la suppression d'éléments.
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddHabitSheet = true // Déclenche l'affichage de la feuille modale.
                    }) {
                        Image(systemName: "plus.circle.fill") // Icône standard pour l'action d'ajout.
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabitSheet) {
                // Présente la vue AddHabitView en tant que feuille modale.
                // Il est crucial de passer l'instance `appData` à la vue présentée
                // pour qu'elle puisse interagir avec les données de l'application.
                AddHabitView().environmentObject(appData)
            }
        }
    }

    /// Supprime des habitudes de la liste en fonction des `IndexSet` fournis.
    ///
    /// Cette fonction est appelée par le modificateur `.onDelete` appliqué à la `List`.
    /// Elle transmet l'action de suppression à la méthode `deleteHabits(at:)` de l'objet ``AppData``.
    ///
    /// - Parameter offsets: Un `IndexSet` contenant les indices des habitudes à supprimer
    ///   dans la liste `appData.habits`.
    private func deleteHabits(at offsets: IndexSet) {
        appData.deleteHabits(at: offsets)
    }
}

/// Fournit un aperçu pour `HabitsView` dans Xcode Previews.
///
/// Cette structure permet de visualiser et d'interagir avec `HabitsView`
/// pendant le développement. Une instance de `AppData` est créée et peut être
/// pré-remplie avec des données d'exemple (habitudes) pour simuler différents états
/// de la vue et du graphique de complétion.
struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        // Crée une instance d'AppData pour la prévisualisation.
        let sampleAppData = AppData()
        // Pré-remplir avec quelques habitudes pour un meilleur aperçu du graphique et de la liste.
        // Assurez-vous que votre type Habit a un initialiseur qui correspond ou ajustez en conséquence.
        // Si Habit est Identifiable par un `id` généré automatiquement, vous n'avez pas besoin de le spécifier ici.
        sampleAppData.habits = [
            Habit(name: "Faire du sport", points: 20, isCompletedToday: true),
            Habit(name: "Lire un livre", points: 10, isCompletedToday: false),
            Habit(name: "Méditer", points: 15, isCompletedToday: true),
            Habit(name: "Boire de l'eau", points: 5, isCompletedToday: false)
        ]
        // Injecte l'instance d'AppData dans l'environnement de la vue d'aperçu.
        return HabitsView().environmentObject(sampleAppData)
    }
}
