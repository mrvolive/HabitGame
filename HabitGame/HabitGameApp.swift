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
/// et affiche la vue initiale, qui est `MainTabView`.
@main
struct HabitGameApp: App {
    /// Le corps de l'application, définissant la scène principale.
    ///
    /// Cette propriété retourne une scène qui contient la hiérarchie des vues de l'application.
    /// La `WindowGroup` est utilisée ici pour gérer les fenêtres de l'application,
    /// et elle présente `MainTabView` comme contenu initial.
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

/// Fournit un aperçu pour `HabitGameApp` dans Xcode.
///
/// Cette structure permet de visualiser `MainTabView` directement dans le canevas
/// de prévisualisation d'Xcode, facilitant le développement et le débogage de l'interface utilisateur.
struct HabitGameApp_Previews: PreviewProvider {
    /// Le contenu de l'aperçu.
    ///
    /// Retourne une instance de `MainTabView` pour la prévisualisation.
    static var previews: some View {
        MainTabView()
    }
}
