import 'package:go_router/go_router.dart';
import '../../features/game/presentation/pages/main_menu_page.dart';
import '../../features/game/presentation/pages/shooter_game_page.dart';
import '../../features/game/presentation/pages/settings_page.dart';
import '../../features/game/presentation/pages/shop_page.dart';
import '../../features/game/presentation/pages/inventory_page.dart';
import '../../features/game/presentation/pages/levels_page.dart';
import '../../features/game/presentation/pages/leaderboard_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/menu',
    routes: [
      GoRoute(
        path: '/menu',
        builder: (context, state) => const MainMenuPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const ShooterGamePage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/levels',
        builder: (context, state) => const LevelsPage(),
      ),
      GoRoute(
        path: '/shop',
        builder: (context, state) => const ShopPage(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryPage(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardPage(),
      ),
    ],
  );
}

