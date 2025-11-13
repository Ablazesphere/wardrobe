# Navigation with GoRouter

This app uses **GoRouter** for navigation, which provides declarative routing with deep linking support and seamless integration with Riverpod.

## Features

- ✅ **Declarative Routing**: Define routes in one place
- ✅ **Auth Guards**: Automatic redirects based on authentication state
- ✅ **Deep Linking**: Support for URLs and deep links
- ✅ **Type-Safe**: Named routes for better IDE support
- ✅ **Riverpod Integration**: Works seamlessly with state management

## Usage

### Basic Navigation

```dart
import 'package:go_router/go_router.dart';

// Push a new route (keeps current route in stack)
context.push('/signup');

// Go to a route (replaces current route)
context.go('/home');

// Pop current route
context.pop();
```

### Named Routes

```dart
// Using named routes
context.goNamed('login');
context.pushNamed('signup');
```

### Navigation Helper

```dart
import 'router/navigation_helper.dart';

// Use helper methods for type-safe navigation
AppNavigation.toLogin(context);  // Go to login (replaces current)
AppNavigation.pushSignup(context); // Push signup (keeps current in stack)
```

## Route Configuration

Routes are defined in `lib/router/app_router.dart`. Add new routes there:

```dart
GoRoute(
  path: '/home',
  name: 'home',
  builder: (context, state) => const HomeScreen(),
),
```

## Auth Guards

The router automatically redirects based on authentication state:

- **Not authenticated** → Redirects to `/login`
- **Authenticated** → Redirects away from auth screens to `/home`

This is handled in the `redirect` callback in `app_router.dart`.

## Adding New Routes

1. Add the route in `app_router.dart`
2. Optionally add helper method in `navigation_helper.dart`
3. Use `context.go()` or `context.push()` to navigate

