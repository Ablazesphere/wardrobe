import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation helper class for type-safe navigation
class AppNavigation {
  // Auth routes
  static void toLogin(BuildContext context) => context.go('/login');
  static void toSignup(BuildContext context) => context.go('/signup');
  
  // Navigation methods
  static void pushLogin(BuildContext context) => context.push('/login');
  static void pushSignup(BuildContext context) => context.push('/signup');
  
  // Future: Add more routes as your app grows
  // static void toHome(BuildContext context) => context.go('/home');
  // static void toProfile(BuildContext context) => context.go('/profile');
}

