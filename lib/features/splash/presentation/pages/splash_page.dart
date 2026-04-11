import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _navigateToHome();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/rooms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0f0f),
      body: Stack(
        children: [
          // Radial gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF1a4a45),
                  Color(0xFF0a0f0f),
                  Color(0xFF000000),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo section with animations
                SizedBox(
                  width: 128,
                  height: 128,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ambient glow background
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF66d9cc)
                                  .withValues(alpha: 0.2),
                              blurRadius: 32,
                              spreadRadius: 16,
                            ),
                          ],
                        ),
                      ),
                      // Outer ring
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF66d9cc)
                                .withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // Inner animated core
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.8, end: 1.0)
                            .animate(_animationController),
                        child: Transform.rotate(
                          angle: 0.785, // 45 degrees
                          child: Container(
                            width: 90.51,
                            height: 90.51,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF66d9cc),
                                  Color(0xFF008177),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF66d9cc)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 40,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Transform.rotate(
                                angle: -0.785, // Counter-rotate
                                child: Container(
                                  width: 27,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Floating accents top-right
                      Positioned(
                        top: 16,
                        right: 16,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: const Interval(0.3, 0.8),
                                ),
                              ),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Color(0xFF99cbff),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      // Floating accents bottom-left
                      Positioned(
                        bottom: 32,
                        left: 0,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: const Interval(0.5, 1.0),
                                ),
                              ),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFbbc4f7),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Text content
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.2, 0.8),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Heading
                      Text(
                        'MALAZ',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                          color: const Color(0xFFdfe3e2),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subheading
                      Text(
                        'THE FLOW STATE SANCTUARY',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(
                          color: const Color(0xFFbdc9c8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
