import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:AceDeck/components/glass_container.dart';
import 'GameMenu.dart'; // Assuming GameScreen is in GameMenu.dart

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final _currentPageNotifier = ValueNotifier<int>(0);

  List<String> animationList = [
    'images/Animation1.json',
    'images/Animation2.json',
    'images/Animation3.json',
  ];

  List<String> pageTexts = [
    'Welcome to AceDeck!',
    'Tired of writing scores on paper?',
    'Get excited to play!',
  ];
  List<String> subpageTexts = [
    "AceDeck is a digital scorecard that allows you to keep track of your scores and stats while playing card games.",
    "The app will keep track of your scores and stats while playing card games.",
    "Let's Get Started And Play!"
  ];

  void _nextPage() {
    if (_currentPage < animationList.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D0D1A),
              Color(0xFF2D1B5E),
              Color(0xFF0A0A18),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                  _currentPageNotifier.value = page;
                });
              },
              itemCount: animationList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(animationList[index],
                          key: Key(index.toString()), height: 280),
                      const SizedBox(height: 24.0),
                      CirclePageIndicator(
                        dotColor: Colors.white30,
                        selectedDotColor: Colors.white,
                        itemCount: animationList.length,
                        currentPageNotifier: _currentPageNotifier,
                      ),
                      const SizedBox(height: 20.0),
                      GlassContainer(
                        borderRadius: 20,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              pageTexts[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'BlackOpsOne',
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              subpageTexts[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      GlassContainer(
                        borderRadius: 30,
                        padding: EdgeInsets.zero,
                        tintColor: const Color(0x33FFFFFF),
                        child: MaterialButton(
                          onPressed: _nextPage,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48.0, vertical: 16.0),
                          child: Text(
                            _currentPage < animationList.length - 1
                                ? 'Next'
                                : "Let's Get Started",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
