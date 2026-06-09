import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/calories/screens/calories_screen.dart';
import '../features/exercises/screens/exercises_screen.dart';
import '../features/photos/screens/photos_screen.dart';
import '../features/subscribe/screens/subscribe_screen.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      if (!auth.initialized) return null;
      final onLogin = state.matchedLocation == '/login';
      if (!auth.isLoggedIn && !onLogin) return '/login';
      if (auth.isLoggedIn && onLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/calories', builder: (_, _) => const CaloriesScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/exercises', builder: (_, _) => const ExercisesScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/photos', builder: (_, _) => const PhotosScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/subscribe', builder: (_, _) => const SubscribeScreen()),
            ],
          ),
        ],
      ),
    ],
  );
});

final class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: 'Calories'),
    NavigationDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: 'Exercises'),
    NavigationDestination(icon: Icon(Icons.photo_library_outlined), selectedIcon: Icon(Icons.photo_library), label: 'Photos'),
    NavigationDestination(icon: Icon(Icons.stars_outlined), selectedIcon: Icon(Icons.stars), label: 'Subscribe'),
  ];

  static const _railDestinations = [
    NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
    NavigationRailDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: Text('Calories')),
    NavigationRailDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: Text('Exercises')),
    NavigationRailDestination(icon: Icon(Icons.photo_library_outlined), selectedIcon: Icon(Icons.photo_library), label: Text('Photos')),
    NavigationRailDestination(icon: Icon(Icons.stars_outlined), selectedIcon: Icon(Icons.stars), label: Text('Subscribe')),
  ];

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) return _desktopShell(index);

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) => navigationShell.goBranch(i),
            destinations: _destinations,
          ),
        );
      },
    );
  }

  Widget _desktopShell(int index) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (i) => navigationShell.goBranch(i),
            labelType: NavigationRailLabelType.all,
            destinations: _railDestinations,
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
