//
//  AddRewardView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI

/// Une vue SwiftUI permettant à l'utilisateur d'ajouter une nouvelle récompense à l'application.
///
/// Cette vue présente un formulaire où l'utilisateur peut saisir le nom et le coût en points
/// de la nouvelle récompense. Elle utilise ``AppData`` pour ajouter la récompense à la liste
/// globale et `Environment(\.dismiss)` pour se fermer après l'ajout.
struct AddRewardView: View {
    /// L'instance partagée de ``AppData`` qui gère les données globales de l'application.
    ///
    /// Utilisée ici pour accéder à la méthode `addReward` afin d'enregistrer la nouvelle récompense.
    @EnvironmentObject var appData: AppData
    
    /// Une action pour fermer (dismiss) la vue actuelle.
    ///
    /// Injectée via l'environnement SwiftUI, elle est appelée pour retourner à la vue précédente
    /// après avoir ajouté une récompense ou annulé l'opération.
    @Environment(\.dismiss) var dismiss

    /// Le nom de la nouvelle récompense, lié au champ de texte correspondant.
    ///
    /// Cette propriété d'état (`@State`) est mise à jour dynamiquement lorsque l'utilisateur tape
    /// dans le champ "Nom de la récompense".
    @State private var name: String = ""
    
    /// Le coût de la nouvelle récompense, sous forme de chaîne de caractères, lié au champ de texte.
    ///
    /// Cette propriété d'état (`@State`) stocke l'entrée brute de l'utilisateur pour le coût.
    /// Elle est ensuite convertie en `Int` avant d'être sauvegardée. L'utilisation d'une chaîne
    /// permet une saisie plus flexible et la gestion du `keyboardType(.numberPad)`.
    @State private var costString: String = ""

    /// Une propriété calculée qui détermine si le bouton d'ajout doit être activé.
    ///
    /// Le bouton est activé uniquement si le nom de la récompense n'est pas vide (après suppression
    /// des espaces blancs) et si le coût saisi est un nombre entier valide supérieur à zéro.
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (Int(costString) ?? 0) > 0
    }

    /// Le corps de la vue, décrivant l'interface utilisateur.
    ///
    /// Il se compose d'une `NavigationView` contenant un `Form` avec des champs pour le nom
    /// et le coût de la récompense, ainsi qu'un bouton pour ajouter la récompense.
    /// Une barre d'outils (`toolbar`) contient un bouton "Annuler".
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails de la récompense")) {
                    TextField("Nom de la récompense (ex: Film)", text: $name)
                    TextField("Coût en points (ex: 100)", text: $costString)
                        .keyboardType(.numberPad) // Affiche un clavier numérique pour la saisie du coût
                }

                Button("Ajouter la récompense") {
                    if let cost = Int(costString) { // Tente de convertir le coût en entier
                        // Ajoute la récompense via appData après avoir nettoyé le nom
                        appData.addReward(name: name.trimmingCharacters(in: .whitespacesAndNewlines), cost: cost)
                        dismiss() // Ferme la vue après l'ajout
                    }
                }
                .disabled(!canSave) // Le bouton est désactivé si `canSave` est faux
            }
            .navigationTitle("Nouvelle Récompense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss() // Ferme la vue sans sauvegarder
                    }
                }
            }
        }
    }
}

/// Fournit un aperçu pour `AddRewardView` dans Xcode Previews.
///
/// Cette structure permet de visualiser et d'interagir avec `AddRewardView`
/// pendant le développement, en lui injectant une instance de `AppData`.
struct AddRewardView_Previews: PreviewProvider {
    static var previews: some View {
        AddRewardView()
            .environmentObject(AppData()) // Injecte une instance d'AppData pour l'aperçu
    }
}
