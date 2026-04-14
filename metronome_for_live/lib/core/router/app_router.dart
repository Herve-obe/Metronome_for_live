import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/edit/screens/projects_screen.dart';
import '../../features/edit/screens/setlists_screen.dart';
import '../../features/edit/screens/songs_screen.dart';
import '../../features/edit/screens/block_editor_screen.dart';
import '../../features/live/screens/live_screen.dart';
import '../theme/app_colors.dart';

/// Shell pour la navigation par onglets (bottom tab).
class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/live')) {
      currentIndex = 0;
    } else if (location.startsWith('/rehearsal')) {
      currentIndex = 1;
    } else if (location.startsWith('/edit')) {
      currentIndex = 2;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accentDim,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/live');
            case 1:
              context.go('/rehearsal');
            case 2:
              context.go('/edit');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.flash_on_outlined),
            selectedIcon: Icon(Icons.flash_on, color: AppColors.accent),
            label: 'Live',
          ),
          NavigationDestination(
            icon: Icon(Icons.music_note_outlined),
            selectedIcon: Icon(Icons.music_note, color: AppColors.accent),
            label: 'Rehearsal',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_outlined),
            selectedIcon: Icon(Icons.edit, color: AppColors.accent),
            label: 'Edit',
          ),
        ],
      ),
    );
  }
}

/// Configuration du routeur de l'application.
final appRouter = GoRouter(
  initialLocation: '/edit',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _ScaffoldWithNavBar(child: child),
      routes: [
        // ─── Live ────────────────────────────────────────
        GoRoute(
          path: '/live',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LiveScreen(),
          ),
        ),
        // ─── Rehearsal (placeholder pour Phase 2) ────────
        GoRoute(
          path: '/rehearsal',
          pageBuilder: (context, state) => NoTransitionPage(
            child: Scaffold(
              appBar: AppBar(title: const Text('Rehearsal')),
              body: const Center(
                child: Text(
                  'Coming in Phase 2',
                  style: TextStyle(color: AppColors.textDim),
                ),
              ),
            ),
          ),
        ),
        // ─── Edit ────────────────────────────────────────
        GoRoute(
          path: '/edit',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProjectsScreen(),
          ),
          routes: [
            GoRoute(
              path: 'project/:projectId',
              builder: (context, state) => SetlistsScreen(
                projectId: state.pathParameters['projectId']!,
              ),
              routes: [
                GoRoute(
                  path: 'setlist/:setlistId',
                  builder: (context, state) => SongsScreen(
                    setlistId: state.pathParameters['setlistId']!,
                    projectId: state.pathParameters['projectId']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'song/:songId',
                      builder: (context, state) => BlockEditorScreen(
                        songId: state.pathParameters['songId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
