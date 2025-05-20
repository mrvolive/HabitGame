import SwiftUI

/// La vue principale de l'application, organisée avec une barre d'onglets (`TabView`).
///
/// `MainTabView` sert de conteneur racine pour les différentes sections principales de l'application :
/// - `HabitsView`: Pour afficher et gérer les habitudes.
/// - `RewardsView`: Pour afficher et acheter des récompenses.
/// - `PointsHistoryView`: Pour visualiser l'historique des points gagnés.
///
/// Elle initialise et injecte une instance de `AppData` en tant qu'objet d'environnement
/// pour que les vues enfants puissent y accéder et partager les mêmes données d'application.
struct MainTabView: View {
    /// L'instance de `AppData` qui gère l'état global de l'application.
    ///
    /// `@StateObject` garantit que `appData` est initialisé une seule fois pour la durée de vie de `MainTabView`
    /// et est partagé avec les vues enfants via `.environmentObject()`.
    @StateObject var appData = AppData()

    /// Le corps de la vue, définissant la structure de l'interface utilisateur.
    ///
    /// Utilise un `TabView` pour permettre la navigation entre les différentes sections principales.
    /// Chaque onglet est configuré avec une `Label` (texte et image système) et injecte
    /// l'instance `appData` dans l'environnement de la vue correspondante.
    var body: some View {
        TabView {
            HabitsView()
                .tabItem {
                    Label("Habitudes", systemImage: "list.bullet.clipboard")
                }
                .environmentObject(appData) // Partage appData avec HabitsView

            RewardsView()
                .tabItem {
                    Label("Boutique", systemImage: "giftcard")
                }
                .environmentObject(appData) // Partage appData avec RewardsView

            PointsHistoryView()
                .tabItem {
                    Label("Historique", systemImage: "chart.bar.xaxis")
                }
                .environmentObject(appData) // Partage appData avec PointsHistoryView
        }
    }
}

/// Fournit un aperçu pour `MainTabView` dans Xcode.
///
/// Cette structure permet de visualiser `MainTabView` directement dans le canevas
/// de prévisualisation d'Xcode, ce qui est utile pour le développement et le débogage
/// de l'interface utilisateur.
struct MainTabView_Previews: PreviewProvider {
    /// Le contenu de l'aperçu.
    ///
    /// Retourne une instance de `MainTabView` pour la prévisualisation.
    /// L'instance `AppData` sera initialisée au sein de cette instance de `MainTabView`.
    static var previews: some View {
        MainTabView()
    }
}
