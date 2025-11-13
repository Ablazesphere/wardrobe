import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/login_form_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    
    // Get state from providers
    final loginFormState = ref.watch(loginFormProvider);
    final authState = ref.watch(authProvider);
    
    // Responsive dimensions
    final imageHeight = screenHeight * 0.45; // 40% of screen height
    final cardHeight = screenHeight * 0.55; // 60% of screen height
    final borderRadius = screenWidth * 0.15; // Responsive border radius (15% of screen width)

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Image section (top 40%)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: imageHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(borderRadius),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 14, 48, 16), // Dark green color
                          BlendMode.color,
                        ),
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            'assets/images/wardrobe_malfunction.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.5, 1.0],
                              colors: [
                                Colors.transparent,
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Centered logo and text
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.25,
                              height: screenWidth * 0.25,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 194, 27),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.door_sliding_rounded,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Welcome Back!',
                              style: GoogleFonts.prompt(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
                // Black card behind Card#1
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: cardHeight,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                ),
                // Card#1 (white card on top)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: cardHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          // Email Address Field
                          Text(
                            'Email Address',
                            style: GoogleFonts.prompt(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            onChanged: (value) {
                              ref.read(loginFormProvider.notifier).updateEmail(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'johnwilliams@gmail.com',
                              hintStyle: GoogleFonts.prompt(
                                color: Colors.grey[400],
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            style: GoogleFonts.prompt(),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Password Field
                          Text(
                            'Password',
                            style: GoogleFonts.prompt(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: loginFormState.obscurePassword,
                            onChanged: (value) {
                              ref.read(loginFormProvider.notifier).updatePassword(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: GoogleFonts.prompt(
                                color: Colors.grey[400],
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  loginFormState.obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  ref.read(loginFormProvider.notifier).togglePasswordVisibility();
                                },
                              ),
                            ),
                            style: GoogleFonts.prompt(),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Remember me and Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: loginFormState.rememberMe,
                                    onChanged: (value) {
                                      ref.read(loginFormProvider.notifier).toggleRememberMe();
                                    },
                                    activeColor: const Color.fromARGB(255, 14, 48, 16),
                                  ),
                                  Text(
                                    'Remember me',
                                    style: GoogleFonts.prompt(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.prompt(
                                    fontSize: 14,
                                    color: const Color.fromARGB(255, 14, 48, 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          // Error message
                          if (authState.error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                authState.error!,
                                style: GoogleFonts.prompt(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          // LOGIN Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : () async {
                                      await ref.read(authProvider.notifier).login(
                                            loginFormState.email,
                                            loginFormState.password,
                                          );
                                      if (ref.read(authProvider).isAuthenticated && mounted) {
                                        // Navigation will be handled automatically by router redirect
                                        context.go('/home');
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 14, 48, 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'LOGIN',
                                      style: GoogleFonts.prompt(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Sign up link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: GoogleFonts.prompt(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.push('/signup');
                                  },
                                  child: Text(
                                    'SIGN UP',
                                    style: GoogleFonts.prompt(
                                      fontSize: 14,
                                      color: const Color.fromARGB(255, 14, 48, 16),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

