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

// Écran 1: Liste des Tâches (Habitudes)
struct HabitsView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        NavigationView {
            List {
                ForEach($appData.habits) { $habit in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(habit.name)
                                .font(.headline)
                            Text("\(habit.points) points")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            appData.completeHabit(habit: habit)
                        }) {
                            Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(habit.isCompletedToday ? .green : .gray)
                                .imageScale(.large)
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Pour éviter que toute la ligne soit cliquable
                    }
                }
            }
            .navigationTitle("Mes Habitudes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Éditer") {
                        // Action pour éditer les habitudes (ex: mode édition de la liste)
                        print("Bouton Éditer (Habitudes) cliqué")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action pour ajouter une nouvelle habitude (ex: afficher une modale)
                        print("Bouton Ajouter (Habitudes) cliqué")
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

// Écran 2: Boutique - Récompenses
struct RewardsView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        NavigationView {
            VStack {
                Text("Mes Points: \(appData.currentPoints)")
                    .font(.title2)
                    .padding()

                List {
                    ForEach(appData.rewards) { reward in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(reward.name)
                                    .font(.headline)
                                Text("\(reward.cost) points")
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                            }
                            Spacer()
                            if appData.currentPoints >= reward.cost {
                                Button("Acheter") {
                                    appData.buyReward(reward: reward)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                            } else {
                                Text("Insuffisant")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Boutique")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Éditer") {
                        // Action pour éditer les récompenses
                        print("Bouton Éditer (Récompenses) cliqué")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action pour ajouter une nouvelle récompense
                        print("Bouton Ajouter (Récompenses) cliqué")
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

// Écran 3: Solde de points (Historique)
struct PointsHistoryView: View {
    @EnvironmentObject var appData: AppData
    let daysOrder = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim", "Auj."] // Pour l'ordre

    // Simple graphique à barres
    var body: some View {
        NavigationView {
            VStack {
                Text("Points Gagnés (Semaine)")
                    .font(.headline)
                    .padding(.top)

                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(appData.pointHistory.sorted(by: { $0.date < $1.date }).suffix(7)) { dailyEntry in // Affiche les 7 derniers jours
                        VStack {
                            Text("\(dailyEntry.points)")
                                .font(.caption)
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 30, height: CGFloat(dailyEntry.points)) // Hauteur proportionnelle aux points
                                .cornerRadius(5)
                            Text(dayString(from: dailyEntry.date))
                                .font(.caption2)
                        }
                    }
                }
                .padding()
                .frame(height: 200) // Hauteur fixe pour le graphique

                Text("Faites glisser pour voir plus (non implémenté)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Historique des Points")
        }
    }
    
    private func dayString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        if Calendar.current.isDateInToday(date) { return "Auj." }
        if Calendar.current.isDateInYesterday(date) { return "Hier" }
        dateFormatter.dateFormat = "EEE" // Ex: "Lun"
        return dateFormatter.string(from: date)
    }
}


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

// MARK: - POINT D'ENTRÉE DE L'APPLICATION

// @main // Décommentez ceci si c'est votre fichier principal d'application
struct GamifiedHabitTrackerApp_Preview: App { // Renommez pour éviter conflit si @main est ailleurs
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

// Pour les previews dans Xcode
struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView().environmentObject(AppData())
    }
}

struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        RewardsView().environmentObject(AppData())
    }
}

struct PointsHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PointsHistoryView().environmentObject(AppData())
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
