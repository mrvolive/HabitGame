//
//  Reward.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation

/// Représente une récompense que l'utilisateur peut débloquer ou acheter avec des points.
///
/// Chaque récompense possède un identifiant unique, un nom descriptif et un coût en points.
/// Cette structure est conçue pour être facilement identifiable, persistante et utilisable
/// dans des collections.
///
/// Elle se conforme aux protocoles :
/// - `Identifiable`: Permet d'identifier de manière unique chaque instance de récompense,
///   utile par exemple dans les listes SwiftUI.
/// - `Codable`: Permet d'encoder et de décoder la structure, facilitant la sauvegarde
///   et le chargement des données (par exemple, en JSON).
/// - `Hashable`: Permet d'utiliser les instances de `Reward` dans des collections
///   qui nécessitent le hachage, comme les `Set` ou comme clés dans un `Dictionary`.
struct Reward: Identifiable, Codable, Hashable {
    /// Un identifiant unique pour la récompense, généré automatiquement.
    ///
    /// Conforme au protocole `Identifiable`.
    var id = UUID()

    /// Le nom de la récompense (par exemple, "Pause café prolongée", "Nouvel avatar").
    var name: String

    /// Le coût en points nécessaire pour obtenir ou débloquer cette récompense.
    var cost: Int
}
