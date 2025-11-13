import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Responsive dimensions
    final borderRadius = screenWidth * 0.15;
    final appBarHeight = screenHeight * 0.15; // 10% of screen height
    final cardHeight = screenHeight * 0.85; // 90% of screen height

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // AppBar with curved bottom corners (10% of screen height)
                SizedBox(
                  height: appBarHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(borderRadius),
                    ),
                    child: AppBar(
                      backgroundColor: const Color.fromARGB(255, 14, 48, 16),
                      title: Text(
                        'Sign Up',
                        style: GoogleFonts.prompt(
                          color: Colors.white,
                        ),
                      ),
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                ),
                // Card below AppBar (90% of screen height) Card#1
                SizedBox(
                  height: cardHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: const Center(
                      child: Text('Sign Up Screen'),
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

