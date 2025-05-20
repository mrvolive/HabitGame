import SwiftUI

// MARK: - MODÈLES DE DONNÉES

struct Habit: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var points: Int
    var isCompletedToday: Bool = false
}

struct Reward: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var cost: Int
}

struct DailyPoints: Identifiable, Hashable {
    var id = UUID()
    var day: String // Ex: "Lun", "Mar"
    var points: Int
    var date: Date = Date() // Pour un tri ou une logique plus avancée
}

// MARK: - CLASSE DE DONNÉES (ObservableObject)

class AppData: ObservableObject {
    @Published var habits: [Habit] = [
        Habit(name: "Faire 1h de sport", points: 20),
        Habit(name: "Lire 30 pages", points: 10),
        Habit(name: "Méditer 10 min", points: 15, isCompletedToday: true),
        Habit(name: "Boire 2L d'eau", points: 5)
    ]

    @Published var rewards: [Reward] = [
        Reward(name: "1h de jeu vidéo", cost: 50),
        Reward(name: "Regarder un film", cost: 100),
        Reward(name: "Sortie entre amis", cost: 150)
    ]

    @Published var currentPoints: Int = 120

    @Published var pointHistory: [DailyPoints] = [
        DailyPoints(day: "Lun", points: 70, date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!),
        DailyPoints(day: "Mar", points: 30, date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!),
        DailyPoints(day: "Mer", points: 10, date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!),
        DailyPoints(day: "Jeu", points: 100, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
        DailyPoints(day: "Ven", points: 5, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        DailyPoints(day: "Sam", points: 30, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        DailyPoints(day: "Dim", points: 50, date: Date())
    ]

    func completeHabit(habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            if !habits[index].isCompletedToday {
                habits[index].isCompletedToday = true
                currentPoints += habits[index].points
                // Ajouter à l'historique (logique simplifiée pour l'exemple)
                let todayStr = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
                if let historyIndex = pointHistory.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
                    pointHistory[historyIndex].points += habits[index].points
                } else {
                    // Pourrait être plus malin pour le nom du jour
                    pointHistory.append(DailyPoints(day: "Auj.", points: habits[index].points, date: Date()))
                }
            }
        }
    }

    func buyReward(reward: Reward) {
        if currentPoints >= reward.cost {
            currentPoints -= reward.cost
            // Logique supplémentaire si nécessaire (ex: marquer la récompense comme utilisée)
        } else {
            // Gérer le cas où les points sont insuffisants
            print("Points insuffisants pour acheter \(reward.name)")
        }
    }
    
    // TODO: Fonctions pour ajouter/éditer habitudes et récompenses
}

// MARK: - VUES SwiftUI




// MARK: - VUE PRINCIPALE AVEC TABVIEW

struct MainTabView: View {
    @StateObject var appData = AppData()

    var body: some View {
        TabView {
            HabitsView()
                .tabItem {
                    Label("Habitudes", systemImage: "list.bullet.clipboard") // Icône comme sur le croquis
                }
                .environmentObject(appData)

            RewardsView()
                .tabItem {
                    Label("Boutique", systemImage: "giftcard") // Icône comme sur le croquis
                }
                .environmentObject(appData)

            PointsHistoryView()
                .tabItem {
                    Label("Historique", systemImage: "chart.bar.xaxis") // Icône comme sur le croquis
                }
                .environmentObject(appData)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
