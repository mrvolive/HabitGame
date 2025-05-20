//
//  Reward.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation

/// Représente une récompense que l'utilisateur peut débloquer ou acheter en utilisant les points accumulés.
///
/// Chaque récompense est définie par un identifiant unique, un nom descriptif,
/// et le coût en points nécessaire pour l'obtenir. Les récompenses servent à motiver
/// l'utilisateur en lui offrant des objectifs tangibles à atteindre.
///
/// ## Conformances
/// - ``Identifiable``: Assure que chaque récompense peut être identifiée de manière unique,
///   ce qui est crucial pour son utilisation dans des interfaces utilisateur dynamiques comme les listes SwiftUI.
/// - ``Codable``: Permet à la structure d'être facilement encodée et décodée,
///   par exemple pour la sauvegarde et la restauration à partir d'un format comme JSON.
/// - ``Hashable``: Rend les instances de ``Reward`` utilisables dans des collections
///   basées sur le hachage, telles que `Set` ou comme clés dans un `Dictionary`.
struct Reward: Identifiable, Codable, Hashable {
    /// Un identifiant unique et stable pour la récompense.
    ///
    /// Cet identifiant est généré automatiquement via `UUID()` lors de la création
    /// d'une nouvelle instance de ``Reward`` et reste constant.
    /// Il est requis par le protocole ``Identifiable``.
    var id = UUID()

    /// Le nom descriptif de la récompense.
    ///
    /// Ce nom est affiché à l'utilisateur pour qu'il comprenne ce qu'il peut obtenir.
    /// Exemples : `"Pause café prolongée de 15 minutes"`, `"Débloquer un nouvel avatar"`, `"Jour de congé virtuel"`.
    var name: String

    /// Le coût en points nécessaire pour acquérir ou débloquer cette récompense.
    ///
    /// L'utilisateur doit accumuler au moins ce nombre de points pour pouvoir réclamer la récompense.
    var cost: Int
}
