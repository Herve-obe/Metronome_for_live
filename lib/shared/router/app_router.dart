
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metronome_for_live/features/live/live_screen.dart';
import 'package:metronome_for_live/features/creation/creation_screen.dart';
import 'package:metronome_for_live/features/rehearsal/rehearsal_screen.dart';
import 'package:metronome_for_live/shared/widgets/scaffold_with_nav_bar.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/live',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/live',
                builder: (context, state) => const LiveScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rehearsal',
                builder: (context, state) => const RehearsalScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/creation',
                builder: (context, state) => const CreationScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
