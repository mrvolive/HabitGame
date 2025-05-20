//
//  CompletionCircleView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI

/// Une vue SwiftUI qui affiche un cercle de progression.
///
/// Cette vue est utilisée pour visualiser un pourcentage d'achèvement sous forme de cercle
/// avec un texte indiquant la valeur numérique. Elle est personnalisable en termes de couleur,
/// d'épaisseur de ligne et de taille de police.
struct CompletionCircleView: View {
    /// La progression actuelle du cercle, représentée par une valeur entre 0.0 (0%) et 1.0 (100%).
    ///
    /// Les valeurs en dehors de cet intervalle seront bornées à 0.0 ou 1.0 pour l'affichage.
    var progress: Double
    
    /// La couleur du segment du cercle qui indique la progression.
    ///
    /// La valeur par défaut est `.green`.
    var circleColor: Color = .green
    
    /// La couleur du cercle d'arrière-plan, qui représente la partie non complétée.
    ///
    /// La valeur par défaut est `Color.gray.opacity(0.2)`.
    var backgroundColor: Color = Color.gray.opacity(0.2)
    
    /// L'épaisseur de la ligne pour le cercle de progression et le cercle d'arrière-plan.
    ///
    /// La valeur par défaut est `20.0` points.
    var lineWidth: CGFloat = 20.0
    
    /// La taille de la police pour le texte du pourcentage affiché au centre du cercle.
    ///
    /// La valeur par défaut est `.title`.
    var percentageFontSize: Font = .title

    /// Le corps de la vue, décrivant l'interface utilisateur du cercle de progression.
    ///
    /// Il est composé d'un `ZStack` contenant :
    /// 1. Un `Circle` pour l'arrière-plan.
    /// 2. Un `Circle` pour la progression, dont la portion visible est déterminée par la propriété `progress`.
    ///    Ce cercle est animé lors des changements de `progress`.
    /// 3. Un `Text` affichant le pourcentage de progression au centre.
    var body: some View {
        ZStack {
            // Cercle d'arrière-plan
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            // Cercle de progression
            Circle()
                // .trim coupe le cercle pour n'afficher qu'une portion allant de 0 jusqu'à la valeur de `progress`.
                .trim(from: 0, to: CGFloat(min(self.progress, 1.0))) // Assure que progress ne dépasse pas 1.0
                .stroke(circleColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: -90)) // Fait commencer le tracé depuis le haut du cercle (position 12h).
                .animation(.easeOut(duration: 0.5), value: progress) // Anime le changement de progression de manière fluide.

            // Texte affichant le pourcentage
            Text(String(format: "%.0f %%", min(self.progress, 1.0) * 100.0)) // Formate le progress en pourcentage (ex: "75 %").
                .font(percentageFontSize)
                .bold()
        }
    }
}

/// Fournit des aperçus pour `CompletionCircleView` dans Xcode Previews.
///
/// Cette structure permet de visualiser `CompletionCircleView` avec différentes configurations
/// de progression, couleurs, et tailles pour faciliter le développement et le test de la vue.
struct CompletionCircleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Exemple avec 0% de progression et une petite taille de police.
            CompletionCircleView(progress: 0.0, percentageFontSize: .caption)
                .frame(width: 80, height: 80)
            
            // Exemple avec 33% de progression.
            CompletionCircleView(progress: 0.33)
                .frame(width: 150, height: 150)
            
            // Exemple avec 75% de progression, une couleur bleue et une épaisseur de ligne plus fine.
            CompletionCircleView(progress: 0.75, circleColor: .blue, lineWidth: 10)
                .frame(width: 100, height: 100)
            
            // Exemple avec 100% de progression et une couleur orange.
            CompletionCircleView(progress: 1.0, circleColor: .orange)
                .frame(width: 120, height: 120)
            
            // Exemple testant la limite supérieure (progress > 1.0), qui devrait être bornée à 100%.
            CompletionCircleView(progress: 1.2, circleColor: .purple)
                .frame(width: 120, height: 120)
        }
        .padding() // Ajoute un peu d'espace autour du VStack pour une meilleure visualisation.
    }
}
