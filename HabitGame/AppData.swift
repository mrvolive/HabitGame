//
//  AppData.swift
//  HabitGame
//
//  Created by maraval olivier on 20/05/2025.
//

import Foundation
import SwiftUI // Importer SwiftUI pour ObservableObject et @Published

/// Gère l'état global et les données de l'application HabitGame.
///
/// Cette classe est un `ObservableObject` qui stocke les listes d'habitudes, de récompenses,
/// le nombre de points actuels de l'utilisateur, et l'historique des points gagnés.
/// Les vues SwiftUI peuvent s'abonner aux changements de cet objet pour se mettre à jour
/// automatiquement lorsque les données changent.
class AppData: ObservableObject {

    /// La liste des habitudes que l'utilisateur essaie de suivre.
    @Published var habits: [Habit] = [
        Habit(name: "Faire 1h de sport", points: 20),
        Habit(name: "Lire 30 pages", points: 10),
        Habit(name: "Méditer 10 min", points: 15, isCompletedToday: true),
        Habit(name: "Boire 2L d'eau", points: 5)
    ]

    /// La liste des récompenses que l'utilisateur peut acheter avec ses points.
    @Published var rewards: [Reward] = [
        Reward(name: "1h de jeu vidéo", cost: 50),
        Reward(name: "Regarder un film", cost: 100),
        Reward(name: "Sortie entre amis", cost: 150)
    ]

    /// Le nombre total de points actuellement possédés par l'utilisateur.
    @Published var currentPoints: Int = 120 // Initialisé avec les points de l'habitude déjà complétée

    /// L'historique des points gagnés par l'utilisateur, agrégés par jour.
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
    
    /// Ajoute une nouvelle habitude à la liste.
    func addHabit(name: String, points: Int) {
        let newHabit = Habit(name: name, points: points)
        habits.append(newHabit)
    }

    /// Supprime des habitudes de la liste en fonction de leurs positions.
    func deleteHabits(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
    
    private func addPointsToHistory(points: Int, for date: Date) {
        let calendar = Calendar.current
        let targetDate = calendar.startOfDay(for: date)

        if let historyIndex = pointHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: targetDate) }) {
            pointHistory[historyIndex].points += points
        } else {
            pointHistory.append(DailyPoints(points: points, date: targetDate))
            pointHistory.sort { $0.date < $1.date }
        }
    }

    private func subtractPointsFromHistory(points: Int, for date: Date) {
        let calendar = Calendar.current
        let targetDate = calendar.startOfDay(for: date)

        if let historyIndex = pointHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: targetDate) }) {
            pointHistory[historyIndex].points -= points
            if pointHistory[historyIndex].points < 0 {
                pointHistory[historyIndex].points = 0
            }
        }
    }

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

    // MARK: - Récompenses

    /// Ajoute une nouvelle récompense à la liste.
    /// - Parameters:
    ///   - name: Le nom de la nouvelle récompense.
    ///   - cost: Le coût en points de la nouvelle récompense.
    func addReward(name: String, cost: Int) {
        let newReward = Reward(name: name, cost: cost)
        rewards.append(newReward)
    }

    /// Supprime des récompenses de la liste en fonction de leurs positions.
    /// - Parameter offsets: Un ensemble d'index indiquant les récompenses à supprimer.
    func deleteRewards(at offsets: IndexSet) {
        rewards.remove(atOffsets: offsets)
    }

    /// Permet à l'utilisateur d'acheter une récompense en utilisant ses points.
    func buyReward(reward: Reward) {
        if currentPoints >= reward.cost {
            currentPoints -= reward.cost
            print("\(reward.name) achetée !")
            // Optionnel: supprimer la récompense après l'achat ou la marquer comme possédée
            // if let index = rewards.firstIndex(where: { $0.id == reward.id }) {
            //     rewards.remove(at: index)
            // }
        } else {
            print("Points insuffisants pour acheter \(reward.name). Vous avez \(currentPoints) points, il en faut \(reward.cost).")
        }
    }
}
