import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSignup = state.matchedLocation == '/signup';

      // If not authenticated and trying to access protected routes
      if (!isAuthenticated && !isGoingToLogin && !isGoingToSignup) {
        return '/login';
      }

      // If authenticated and trying to access auth screens
      if (isAuthenticated && (isGoingToLogin || isGoingToSignup)) {
        return '/home'; // Change to your home route when created
      }

      return null; // No redirect needed
    },
    refreshListenable: GoRouterRefreshStream(ref),
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignupScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Slide from right to left (appears as left to right when pushing)
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        ),
      ),
      // Add more routes here as your app grows
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => const HomeScreen(),
      // ),
    ],
  );
});

// Helper class to make auth state listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this.ref) {
    _subscription = ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }

  final Ref ref;
  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

