//
//  CompletionCircleView.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import SwiftUI

struct CompletionCircleView: View {
    /// La progression du cercle, de 0.0 à 1.0.
    var progress: Double
    /// La couleur du cercle de progression.
    var circleColor: Color = .green
    /// La couleur du cercle d'arrière-plan.
    var backgroundColor: Color = Color.gray.opacity(0.2)
    /// L'épaisseur de la ligne du cercle.
    var lineWidth: CGFloat = 20.0
    /// La taille de la police pour le texte du pourcentage.
    var percentageFontSize: Font = .title

    var body: some View {
        ZStack {
            // Cercle d'arrière-plan
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            // Cercle de progression
            Circle()
                // .trim coupe le cercle pour n'afficher qu'une portion
                .trim(from: 0, to: CGFloat(min(self.progress, 1.0))) // Assure que progress ne dépasse pas 1.0
                .stroke(circleColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: -90)) // Fait commencer le tracé depuis le haut du cercle
                .animation(.easeOut(duration: 0.5), value: progress) // Anime le changement de progression

            // Texte affichant le pourcentage
            Text(String(format: "%.0f %%", min(self.progress, 1.0) * 100.0))
                .font(percentageFontSize)
                .bold()
        }
    }
}

struct CompletionCircleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CompletionCircleView(progress: 0.0, percentageFontSize: .caption)
                .frame(width: 80, height: 80)
            CompletionCircleView(progress: 0.33)
                .frame(width: 150, height: 150)
            CompletionCircleView(progress: 0.75, circleColor: .blue, lineWidth: 10)
                .frame(width: 100, height: 100)
            CompletionCircleView(progress: 1.0, circleColor: .orange)
                .frame(width: 120, height: 120)
            CompletionCircleView(progress: 1.2, circleColor: .purple) // Teste la limite à 1.0
                .frame(width: 120, height: 120)
        }
        .padding()
    }
}
