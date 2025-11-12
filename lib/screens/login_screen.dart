import 'package:flutter/material.dart';

class CurvedTopClipper extends CustomClipper<Path> {
  final double curveHeight;
  
  CurvedTopClipper(this.curveHeight);

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = curveHeight * 2;
    
    // Start from top-left corner (slightly elevated)
    path.moveTo(0, waveHeight * 0.3);
    
    // Create smooth S-curve using cubic bezier
    // Left side: curves up to peak in center
    path.cubicTo(
      size.width * 0.0,   // Control point 1 x
      -waveHeight * 0.5,  // Control point 1 y (curves up)
      size.width * 1,   // Control point 2 x
      -waveHeight * 0.5,  // Control point 2 y (reaches peak)
      size.width * 1,   // End point x (center)
      -waveHeight * 0.5, // End point y (peak)
    );
    
    // Right side: curves down from peak
    path.cubicTo(
      size.width * 1,   // Control point 1 x
      -waveHeight * 0.2,  // Control point 1 y (starts curving down)
      size.width * 1,   // Control point 2 x
      waveHeight * 0.4,   // Control point 2 y (curves down)
      size.width,         // End point x (right edge)
      waveHeight * 1,  // End point y (lower on right)
    );
    
    // Complete the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    
    // Responsive dimensions
    final imageHeight = screenHeight * 0.5; // 50% of screen height
    final cardHeight = screenHeight * 0.6; // 60% of screen height
    final curveHeight = screenWidth * 0.1; // Responsive curve height (10% of screen width)

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Image section (top 50%)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: imageHeight,
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
                    ],
                  ),
                ),
                // Card with curved top design (60% of screen)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: cardHeight,
                  child: ClipPath(
                    clipper: CurvedTopClipper(curveHeight),
                    child: Container(
                      color: Colors.white,
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

