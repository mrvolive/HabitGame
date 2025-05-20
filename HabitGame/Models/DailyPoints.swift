//
//  DailyPoint.swift // Note: Le nom du fichier est DailyPoint.swift, mais la structure est DailyPoints.
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation

/// Représente le total des points gagnés par l'utilisateur pour une journée spécifique.
///
/// Cette structure est essentielle pour suivre l'historique des performances de l'utilisateur
/// et pour afficher des statistiques ou des graphiques de progression. Chaque instance
/// encapsule un identifiant unique, le nombre total de points accumulés pour un jour donné,
/// et la date correspondante.
///
/// ## Conformances
/// - ``Identifiable``: Permet à chaque enregistrement de points quotidiens d'être
///   identifié de manière unique, ce qui est utile pour les affichages en liste ou la gestion des données.
/// - ``Hashable``: Permet d'utiliser les instances de ``DailyPoints`` dans des
///   collections basées sur le hachage, comme `Set` ou comme clés dans un `Dictionary`.
///
/// - Note: La structure est nommée `DailyPoints` (au pluriel) pour refléter qu'elle peut contenir
///   les points d'une journée, tandis que le nom de fichier suggéré était `DailyPoint.swift` (au singulier).
///   Il est généralement recommandé d'harmoniser le nom de la structure principale et le nom du fichier.
struct DailyPoints: Identifiable, Hashable {
    /// Un identifiant unique et stable pour cet enregistrement de points quotidiens.
    ///
    /// Généré automatiquement via `UUID()` lors de la création d'une nouvelle instance
    /// et utilisé par le protocole ``Identifiable``.
    var id = UUID()

    /// Le nombre total de points que l'utilisateur a gagnés à la ``date`` spécifiée.
    ///
    /// Ce nombre est la somme des points de toutes les habitudes complétées ce jour-là.
    var points: Int

    /// La date spécifique pour laquelle les ``points`` ont été enregistrés.
    ///
    /// Par défaut, cette propriété est initialisée à la date et à l'heure exactes de la création
    /// de l'instance (`Date()`). Il est souvent judicieux de normaliser cette date
    /// pour ne conserver que le jour, le mois et l'année si l'on souhaite regrouper
    /// les points par journée calendaire.
    var date: Date = Date()
}
