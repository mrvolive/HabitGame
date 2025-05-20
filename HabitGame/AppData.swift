//
//  AppData.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation
import SwiftUI // Importer SwiftUI pour ObservableObject et @Published

/// Gère l'état global et les données persistantes de l'application HabitGame.
///
/// En tant qu'`ObservableObject`, `AppData` publie les changements de ses propriétés,
/// permettant aux vues SwiftUI de s'y abonner et de se mettre à jour automatiquement.
/// Elle centralise la gestion des habitudes, des récompenses, des points de l'utilisateur
/// et de l'historique des points gagnés.
///
/// Les données initiales pour les habitudes, les récompenses, les points et l'historique
/// sont fournies à des fins de démonstration et de test.
class AppData: ObservableObject {

    /// La liste des habitudes que l'utilisateur s'engage à suivre.
    ///
    /// Chaque élément est une instance de ``Habit``. Les modifications de cette liste
    /// (ajout, suppression, complétion d'une habitude) sont publiées aux observateurs.
    ///
    /// Valeurs initiales pour démonstration :
    /// - "Faire 1h de sport" (20 points)
    /// - "Lire 30 pages" (10 points)
    /// - "Méditer 10 min" (15 points, complétée aujourd'hui)
    /// - "Boire 2L d'eau" (5 points)
    @Published var habits: [Habit] = [
        Habit(name: "Faire 1h de sport", points: 20),
        Habit(name: "Lire 30 pages", points: 10),
        Habit(name: "Méditer 10 min", points: 15, isCompletedToday: true),
        Habit(name: "Boire 2L d'eau", points: 5)
    ]

    /// La liste des récompenses disponibles que l'utilisateur peut acquérir avec ses points.
    ///
    /// Chaque élément est une instance de ``Reward``. Les modifications de cette liste
    /// sont publiées aux observateurs.
    ///
    /// Valeurs initiales pour démonstration :
    /// - "1h de jeu vidéo" (coût: 50 points)
    /// - "Regarder un film" (coût: 100 points)
    /// - "Sortie entre amis" (coût: 150 points)
    @Published var rewards: [Reward] = [
        Reward(name: "1h de jeu vidéo", cost: 50),
        Reward(name: "Regarder un film", cost: 100),
        Reward(name: "Sortie entre amis", cost: 150)
    ]

    /// Le solde actuel des points de l'utilisateur.
    ///
    /// Ces points sont gagnés en complétant des habitudes et peuvent être dépensés
    /// pour acheter des récompenses. La valeur initiale est calculée en fonction des habitudes
    /// marquées comme complétées au lancement.
    @Published var currentPoints: Int = 120 // Initialisé avec les points de l'habitude "Méditer 10 min"

    /// L'historique des points gagnés par l'utilisateur, agrégés quotidiennement.
    ///
    /// Chaque élément est une instance de ``DailyPoints``, représentant le total des points
    /// obtenus à une date spécifique. Cette liste est triée par date.
    /// Les données initiales simulent un historique sur plusieurs jours.
    @Published var pointHistory: [DailyPoints] = [
        DailyPoints(points: 50, date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!),
        DailyPoints(points: 70, date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!),
        DailyPoints(points: 30, date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!),
        DailyPoints(points: 10, date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!),
        DailyPoints(points: 100, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
        DailyPoints(points: 5, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        DailyPoints(points: 30, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        DailyPoints(points: 15, date: Date()) // Points de "Méditer" pour aujourd'hui
    ]
    
    /// Ajoute une nouvelle habitude à la liste ``habits``.
    ///
    /// La nouvelle habitude est créée avec le nom et les points spécifiés.
    /// - Parameters:
    ///   - name: Le nom descriptif de la nouvelle habitude.
    ///   - points: Le nombre de points attribués lors de la complétion de cette habitude.
    func addHabit(name: String, points: Int) {
        let newHabit = Habit(name: name, points: points)
        habits.append(newHabit)
    }

    /// Supprime une ou plusieurs habitudes de la liste ``habits`` en fonction de leurs positions.
    /// - Parameter offsets: Un `IndexSet` contenant les index des habitudes à supprimer.
    func deleteHabits(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
    
    /// Met à jour l'historique des points pour une date donnée en ajoutant un certain nombre de points.
    ///
    /// Si un enregistrement ``DailyPoints`` existe déjà pour le jour spécifié (normalisé au début du jour),
    /// les points sont ajoutés à cet enregistrement. Sinon, un nouvel enregistrement est créé.
    /// La liste ``pointHistory`` est ensuite triée par date.
    /// - Parameters:
    ///   - points: Le nombre de points à ajouter.
    ///   - date: La date pour laquelle les points doivent être ajoutés.
    private func addPointsToHistory(points: Int, for date: Date) {
        let calendar = Calendar.current
        let targetDate = calendar.startOfDay(for: date) // Normalise la date au début du jour

        if let historyIndex = pointHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: targetDate) }) {
            pointHistory[historyIndex].points += points
        } else {
            pointHistory.append(DailyPoints(points: points, date: targetDate))
            pointHistory.sort { $0.date < $1.date } // Maintient l'historique trié
        }
    }

    /// Met à jour l'historique des points pour une date donnée en soustrayant un certain nombre de points.
    ///
    /// Si un enregistrement ``DailyPoints`` existe pour le jour spécifié (normalisé au début du jour),
    /// les points sont soustraits. Les points d'un jour ne peuvent pas devenir négatifs (minimum 0).
    /// - Parameters:
    ///   - points: Le nombre de points à soustraire.
    ///   - date: La date pour laquelle les points doivent être soustraits.
    private func subtractPointsFromHistory(points: Int, for date: Date) {
        let calendar = Calendar.current
        let targetDate = calendar.startOfDay(for: date) // Normalise la date au début du jour

        if let historyIndex = pointHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: targetDate) }) {
            pointHistory[historyIndex].points -= points
            if pointHistory[historyIndex].points < 0 {
                pointHistory[historyIndex].points = 0 // Empêche les points négatifs dans l'historique
            }
        }
    }

    /// Marque une habitude comme complétée ou non complétée pour la journée en cours.
    ///
    /// Met à jour l'état `isCompletedToday` de l'habitude, ajuste ``currentPoints``
    /// et met à jour ``pointHistory`` en conséquence.
    /// - Parameter habit: L'instance de ``Habit`` à mettre à jour.
    func completeHabit(habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        
        habits[index].isCompletedToday.toggle()
        let pointsChange = habits[index].points
        let today = Date()

        if habits[index].isCompletedToday {
            currentPoints += pointsChange
            addPointsToHistory(points: pointsChange, for: today)
        } else {
            currentPoints -= pointsChange
            subtractPointsFromHistory(points: pointsChange, for: today)
        }
    }

    // MARK: - Gestion des Récompenses

    /// Ajoute une nouvelle récompense à la liste ``rewards``.
    /// - Parameters:
    ///   - name: Le nom de la nouvelle récompense.
    ///   - cost: Le coût en points de la nouvelle récompense.
    func addReward(name: String, cost: Int) {
        let newReward = Reward(name: name, cost: cost)
        rewards.append(newReward)
    }

    /// Supprime une ou plusieurs récompenses de la liste ``rewards`` en fonction de leurs positions.
    /// - Parameter offsets: Un `IndexSet` contenant les index des récompenses à supprimer.
    func deleteRewards(at offsets: IndexSet) {
        rewards.remove(atOffsets: offsets)
    }

    /// Permet à l'utilisateur d'acheter une récompense si son solde ``currentPoints`` est suffisant.
    ///
    /// Si l'achat est possible, le coût de la récompense est déduit de ``currentPoints``.
    /// Un message est imprimé dans la console pour indiquer le succès ou l'échec de l'achat.
    ///
    /// - Parameter reward: L'instance de ``Reward`` que l'utilisateur souhaite acheter.
    func buyReward(reward: Reward) {
        if currentPoints >= reward.cost {
            currentPoints -= reward.cost
            print("\(reward.name) achetée !")
        } else {
            print("Points insuffisants pour acheter \(reward.name). Vous avez \(currentPoints) points, il en faut \(reward.cost).")
        }
    }
}
