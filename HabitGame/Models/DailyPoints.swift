//
//  DailyPoints.swift // Le nom du fichier est DailyPoint.swift mais la struct est DailyPoints
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation

/// Représente le total des points gagnés par l'utilisateur à une date spécifique.
///
/// Cette structure est utilisée pour enregistrer l'historique des points accumulés.
/// Chaque instance contient un identifiant unique, le nombre de points gagnés, et la date
/// à laquelle ces points ont été enregistrés.
///
/// Elle se conforme aux protocoles `Identifiable` (pour une identification unique) et `Hashable`
/// (pour être utilisable dans des collections nécessitant le hachage).
struct DailyPoints: Identifiable, Hashable {
    /// Un identifiant unique pour cet enregistrement de points quotidiens, généré automatiquement.
    ///
    /// Conforme au protocole `Identifiable`.
    var id = UUID()

    /// Le nombre total de points gagnés à la date spécifiée.
    var points: Int

    /// La date à laquelle les points ont été enregistrés.
    ///
    /// Par défaut, cette valeur est initialisée à la date et l'heure actuelles lors de la création
    /// d'une nouvelle instance.
    var date: Date = Date()
}
