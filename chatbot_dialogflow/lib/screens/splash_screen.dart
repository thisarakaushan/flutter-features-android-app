import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<double> _progressAnimation;

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Initialize animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Start animations and navigation
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    if (_isDisposed || !mounted) return;
    await _logoController.forward();
    if (_isDisposed || !mounted) return;
    await _textController.forward();
    if (_isDisposed || !mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    if (_isDisposed || !mounted) return;
    await _progressController.forward();
    if (_isDisposed || !mounted) return;
    _navigateToChatScreen();
  }

  void _navigateToChatScreen() {
    if (_isDisposed || !mounted) return;
    Navigator.pushReplacementNamed(context, '/chat');
  }

  @override
  void dispose() {
    _isDisposed = true;
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[600]!, Colors.teal[800]!, Colors.indigo[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      AnimatedBuilder(
                        animation: _logoScale,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScale.value,
                            child: Image.asset(
                              'assets/icon.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Animated App Name
                      AnimatedBuilder(
                        animation: _textFade,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textFade.value,
                            child: Column(
                              children: [
                                const Text(
                                  'Dialogflow ChatBot',
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Chat with Intelligence',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      // Animated Progress Indicator
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Column(
                            children: [
                              Container(
                                width: 180,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 180 * _progressAnimation.value,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.tealAccent,
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.tealAccent.withOpacity(
                                            0.4,
                                          ),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Initializing...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
