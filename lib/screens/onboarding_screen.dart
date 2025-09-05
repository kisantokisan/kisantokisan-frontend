import 'package:flutter/material.dart';
import '../design/tokens/tokens.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // State variables for our animations
  double _textOpacity = 0.0;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    // After the screen is built, wait a moment then start the fade-in animation.
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _textOpacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color(0xFFC87641);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/onboarding_background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // This SizedBox adds empty space at the top.
                  const SizedBox(height: 96.0),

                  // AnimatedOpacity makes its child (the text) fade in.
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeIn,
                    opacity: _textOpacity,
                    child: const Column(
                      children: [
                        Text(
                          'Welcome',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: buttonColor,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Rent agricultural tools & tractors',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontSize: 18,
                            color: buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // This block handles the button press animation.
                  GestureDetector(
                    onTapDown: (_) => setState(() => _isButtonPressed = true),
                    onTapUp: (_) {
                      setState(() => _isButtonPressed = false);
                      Navigator.pushNamed(context, '/signin');
                    },
                    onTapCancel: () => setState(() => _isButtonPressed = false),
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 100),
                      scale: _isButtonPressed ? 0.96 : 1.0,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            // The GestureDetector handles navigation,
                            // but we keep this for accessibility.
                            Navigator.pushNamed(context, '/signin');
                          },
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
