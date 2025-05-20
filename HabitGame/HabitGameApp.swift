//
//  HabitGameApp.swift
//  HabitGame
//
//  Created by maraval olivier on 07/05/2025.
//

import SwiftUI

/// L'application principale qui lance l'interface utilisateur de HabitGame.
///
/// `HabitGameApp` est le point d'entrée de l'application. Elle configure la scène principale
/// et affiche la vue initiale, qui est ``MainTabView``.
///
/// ## Vue d'ensemble
/// Cette structure utilise le protocole `App` de SwiftUI pour définir le cycle de vie et
/// la structure de l'interface utilisateur de l'application. La propriété ``body``
/// est responsable de la création de la scène initiale.
@main
struct HabitGameApp: App {
    /// Le corps de l'application, définissant la scène principale.
    ///
    /// Cette propriété calculée retourne une scène qui contient la hiérarchie des vues de l'application.
    /// La `WindowGroup` est utilisée ici pour gérer les fenêtres de l'application sur les plateformes
    /// qui les supportent (comme macOS ou iPadOS avec la multi-fenêtrage),
    /// et elle présente ``MainTabView`` comme contenu initial pour chaque fenêtre.
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

/// Fournit un aperçu pour ``HabitGameApp`` dans Xcode.
///
/// Cette structure se conforme au protocole `PreviewProvider` et est utilisée par Xcode
/// pour afficher un rendu en direct de l'interface utilisateur de l'application directement
/// dans le canevas de prévisualisation. Cela permet de visualiser ``MainTabView``
/// sans avoir à compiler et exécuter l'application complète.
struct HabitGameApp_Previews: PreviewProvider {
    /// Le contenu de l'aperçu.
    ///
    /// Cette propriété statique retourne une instance de ``MainTabView``,
    /// qui sera affichée dans le canevas de prévisualisation d'Xcode.
    static var previews: some View {
        MainTabView()
    }
}
