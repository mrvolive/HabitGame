//
//  Habit.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation

/// Représente une habitude que l'utilisateur souhaite suivre.
///
/// Chaque habitude possède un identifiant unique, un nom descriptif, un nombre de points
/// attribués lors de sa complétion, et un indicateur de son état de complétion pour la journée en cours.
///
/// Cette structure se conforme aux protocoles `Identifiable` (pour être utilisable dans des listes SwiftUI
/// et identifiable de manière unique), `Codable` (pour la persistance des données, par exemple en JSON)
/// et `Hashable` (pour être utilisable dans des collections comme les `Set` ou comme clé de `Dictionary`).
struct Habit: Identifiable, Codable, Hashable {
    /// Un identifiant unique pour l'habitude, généré automatiquement.
    ///
    /// Conforme au protocole `Identifiable`.
    var id = UUID()

    /// Le nom de l'habitude (par exemple, "Faire de l'exercice", "Lire 30 minutes").
    var name: String

    /// Le nombre de points que l'utilisateur gagne lorsque cette habitude est complétée.
    var points: Int

    /// Un booléen indiquant si l'habitude a été marquée comme complétée pour la journée en cours.
    ///
    /// Par défaut, cette valeur est `false` lors de la création d'une nouvelle habitude.
    var isCompletedToday: Bool = false
}
