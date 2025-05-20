//
//  Habit.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation

/// Représente une habitude que l'utilisateur souhaite suivre et gérer dans l'application.
///
/// Chaque habitude est définie par un identifiant unique, un nom descriptif,
/// le nombre de points attribués lors de sa complétion, et un indicateur
/// de son état de complétion pour la journée en cours.
///
/// Cette structure est fondamentale pour le suivi des progrès de l'utilisateur.
///
/// ## Conformances
/// - ``Identifiable``: Permet d'identifier chaque habitude de manière unique,
///   essentiel pour les listes et collections SwiftUI.
/// - ``Codable``: Permet l'encodage et le décodage de l'habitude,
///   facilitant sa persistance (par exemple, sauvegarde en JSON).
/// - ``Hashable``: Permet d'utiliser les instances d'``Habit`` dans des
///   collections basées sur le hachage comme les `Set` ou comme clés de `Dictionary`.
struct Habit: Identifiable, Codable, Hashable {
    /// Un identifiant unique et stable pour l'habitude.
    ///
    /// Généré automatiquement lors de l'initialisation d'une nouvelle instance d'``Habit``
    /// grâce à `UUID()`. Cet identifiant ne change pas pendant la durée de vie de l'objet.
    /// Il est utilisé par le protocole ``Identifiable``.
    var id = UUID()

    /// Le nom descriptif de l'habitude.
    ///
    /// Par exemple : `"Faire de l'exercice"`, `"Lire 30 minutes"`, `"Méditer 10 minutes"`.
    /// Ce nom est affiché à l'utilisateur dans l'interface.
    var name: String

    /// Le nombre de points que l'utilisateur gagne lorsque cette habitude est marquée comme complétée.
    ///
    /// Ces points contribuent au score global de l'utilisateur ou à d'autres mécaniques de jeu.
    var points: Int

    /// Un booléen indiquant si l'habitude a été complétée pour la journée en cours.
    ///
    /// - `true` si l'habitude est marquée comme complétée aujourd'hui.
    /// - `false` si l'habitude n'est pas encore complétée aujourd'hui ou si son état a été réinitialisé.
    ///
    /// La valeur par défaut est `false` lors de la création d'une nouvelle habitude.
    var isCompletedToday: Bool = false
}
