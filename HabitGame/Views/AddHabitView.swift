//
//  AddHabitView.swift
//  HabitGame
//
//  Created by VotreNom (ou maraval olivier) le 20/05/2025.
//

import SwiftUI

/// Une vue SwiftUI permettant à l'utilisateur d'ajouter une nouvelle habitude à l'application.
///
/// Cette vue présente un formulaire où l'utilisateur peut saisir le nom et la valeur en points
/// de la nouvelle habitude. Elle utilise ``AppData`` pour enregistrer l'habitude et
/// `Environment(\.dismiss)` pour se fermer après l'ajout ou l'annulation.
struct AddHabitView: View {
    /// L'instance partagée de ``AppData`` qui gère les données globales de l'application.
    ///
    /// Utilisée ici pour accéder à la méthode `addHabit` afin d'enregistrer la nouvelle habitude.
    @EnvironmentObject var appData: AppData
    
    /// Une action pour fermer (dismiss) la vue actuelle, typiquement une vue modale.
    ///
    /// Injectée via l'environnement SwiftUI, elle est appelée pour retourner à la vue précédente
    /// après avoir ajouté une habitude ou annulé l'opération.
    @Environment(\.dismiss) var dismiss

    /// Le nom de la nouvelle habitude, lié au champ de texte "Nom de l'habitude".
    ///
    /// Cette propriété d'état (`@State`) est mise à jour dynamiquement lorsque l'utilisateur tape
    /// dans le champ de texte.
    @State private var name: String = ""
    
    /// La valeur en points de la nouvelle habitude, saisie sous forme de chaîne de caractères.
    ///
    /// Cette propriété d'état (`@State`) stocke l'entrée brute de l'utilisateur pour les points.
    /// L'utilisation d'une chaîne permet une saisie flexible avec `TextField` et l'utilisation
    /// du `keyboardType(.numberPad)`. Elle est ensuite convertie en `Int` avant d'être sauvegardée.
    @State private var pointsString: String = ""

    /// Une propriété calculée qui détermine si le bouton d'ajout d'habitude doit être activé.
    ///
    /// Le bouton est activé uniquement si :
    /// 1. Le nom de l'habitude (après suppression des espaces blancs en début et fin) n'est pas vide.
    /// 2. La valeur des points, une fois convertie en entier, est supérieure à zéro.
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (Int(pointsString) ?? 0) > 0 // Tente de convertir pointsString en Int, utilise 0 si échec.
    }

    /// Le corps de la vue, décrivant l'interface utilisateur pour l'ajout d'une habitude.
    ///
    /// Il se compose d'une `NavigationView` contenant un `Form`. Le formulaire inclut :
    /// - Une section "Détails de l'habitude" avec des `TextField` pour le nom et les points.
    /// - Un bouton "Ajouter l'habitude" qui, une fois pressé et si les conditions de `canSave` sont remplies,
    ///   ajoute l'habitude et ferme la vue.
    /// La barre de navigation (`toolbar`) contient un bouton "Annuler" pour fermer la vue sans sauvegarder.
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails de l'habitude")) {
                    TextField("Nom de l'habitude (ex: Lire)", text: $name)
                    TextField("Points (ex: 10)", text: $pointsString)
                        .keyboardType(.numberPad) // Affiche un clavier numérique pour la saisie des points.
                }

                Button("Ajouter l'habitude") {
                    if let points = Int(pointsString) { // Tente de convertir la chaîne des points en entier.
                        // Ajoute l'habitude via appData après avoir nettoyé le nom.
                        appData.addHabit(name: name.trimmingCharacters(in: .whitespacesAndNewlines), points: points)
                        dismiss() // Ferme la vue modale après l'ajout réussi.
                    }
                }
                .disabled(!canSave) // Le bouton est désactivé si `canSave` est faux.
            }
            .navigationTitle("Nouvelle Habitude")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss() // Ferme la vue sans effectuer d'action.
                    }
                }
            }
        }
    }
}

/// Fournit un aperçu pour `AddHabitView` dans Xcode Previews.
struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView().environmentObject(AppData())
    }
}
