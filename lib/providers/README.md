# State Management with Riverpod

This app uses **Riverpod** for state management, which is a modern, type-safe, and compile-time safe state management solution for Flutter.

## Structure

### Providers

1. **`auth_provider.dart`** - Manages authentication state
   - Handles login and signup
   - Tracks authentication status
   - Manages loading and error states

2. **`login_form_provider.dart`** - Manages login form state
   - Email and password fields
   - Remember me checkbox
   - Password visibility toggle

## Usage

### Reading State

```dart
// In a ConsumerWidget or ConsumerStatefulWidget
final authState = ref.watch(authProvider);
final loginFormState = ref.watch(loginFormProvider);
```

### Updating State

```dart
// Update form fields
ref.read(loginFormProvider.notifier).updateEmail('user@example.com');

// Trigger login
await ref.read(authProvider.notifier).login(email, password);
```

### Widget Types

- Use `ConsumerWidget` for stateless widgets that need state
- Use `ConsumerStatefulWidget` for stateful widgets that need state
- Access providers using `ref.watch()` to listen to changes
- Access providers using `ref.read()` for one-time reads or actions

## Benefits

- **Type-safe**: Compile-time safety
- **Testable**: Easy to test providers in isolation
- **Reactive**: Automatic UI updates when state changes
- **Performance**: Only rebuilds widgets that depend on changed state
- **Scalable**: Easy to add new providers as the app grows

