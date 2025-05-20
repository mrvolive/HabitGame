import SwiftUI

/// La vue principale de l'application, organisée avec une barre d'onglets (`TabView`).
///
/// `MainTabView` sert de conteneur racine pour les différentes sections principales de l'application,
/// permettant à l'utilisateur de naviguer facilement entre elles. Les sections incluses sont :
/// - ``HabitsView``: Pour afficher, gérer les habitudes quotidiennes et suivre leur complétion.
/// - ``RewardsView``: Pour parcourir et "acheter" des récompenses avec les points accumulés.
/// - ``PointsHistoryView``: Pour visualiser un historique des points gagnés et dépensés.
///
/// Cette vue est responsable de l'initialisation de l'objet d'état global ``AppData``
/// et de son injection en tant qu'objet d'environnement (`.environmentObject`).
/// Cela permet à toutes les vues enfants (les vues d'onglet et leurs sous-vues) d'accéder
/// et de partager de manière cohérente les mêmes données d'application.
struct MainTabView: View {
    /// L'instance de ``AppData`` qui gère l'état global de l'application,
    /// y compris les habitudes, les récompenses, les points et l'historique.
    ///
    /// L'utilisation de `@StateObject` garantit que l'instance `appData` est créée
    /// une seule fois lorsque `MainTabView` est initialisée et qu'elle persiste
    /// pendant toute la durée de vie de la vue. Cette instance est ensuite partagée
    /// avec les vues enfants via le modificateur `.environmentObject()`.
    @StateObject var appData = AppData()

    /// Le corps de la vue, définissant la structure de l'interface utilisateur principale
    /// sous forme d'une barre d'onglets.
    ///
    /// Utilise un `TabView` pour organiser la navigation entre les trois sections principales
    /// de l'application : ``HabitsView``, ``RewardsView``, et ``PointsHistoryView``.
    /// Chaque onglet est configuré avec une `Label` (contenant un texte descriptif et une image système)
    /// pour sa représentation visuelle dans la barre d'onglets.
    /// L'instance `appData` est injectée dans l'environnement de chaque vue d'onglet,
    /// leur donnant accès aux données partagées de l'application.
    var body: some View {
        TabView {
            HabitsView()
                .tabItem {
                    Label("Habitudes", systemImage: "list.bullet.clipboard")
                }
                .environmentObject(appData) // Partage appData avec HabitsView et ses enfants.

            RewardsView()
                .tabItem {
                    Label("Boutique", systemImage: "giftcard")
                }
                .environmentObject(appData) // Partage appData avec RewardsView et ses enfants.

            PointsHistoryView()
                .tabItem {
                    Label("Historique", systemImage: "chart.bar.xaxis")
                }
                .environmentObject(appData) // Partage appData avec PointsHistoryView et ses enfants.
        }
    }
}

/// Fournit un aperçu pour `MainTabView` dans Xcode Previews.
///
/// Cette structure permet de visualiser et d'interagir avec `MainTabView`
/// directement dans le canevas de prévisualisation d'Xcode. Cela est particulièrement
/// utile pour vérifier l'apparence générale de la navigation par onglets et
/// s'assurer que les vues initiales de chaque onglet se chargent correctement.
struct MainTabView_Previews: PreviewProvider {
    /// Le contenu de l'aperçu statique pour `MainTabView`.
    ///
    /// Retourne une instance de `MainTabView`. L'instance ``AppData``
    /// sera initialisée automatiquement au sein de cette instance de `MainTabView`
    /// grâce à la propriété `@StateObject`.
    static var previews: some View {
        MainTabView()
    }
}
