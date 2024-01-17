import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 156, 39, 176),
              Color.fromARGB(255, 33, 20, 100),
            ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(animationList[index],
                          key: Key(index.toString()), height: 300),
                      SizedBox(height: 30.0),
                      CirclePageIndicator(
                        dotColor: Colors.grey,
                        selectedDotColor: Colors.white,
                        itemCount: animationList.length,
                        currentPageNotifier: _currentPageNotifier,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        pageTexts[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        subpageTexts[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 45.0),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue,
                              Colors.purple,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: MaterialButton(
                          onPressed: _nextPage,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          child: Text(
                            _currentPage < animationList.length - 1
                                ? 'Next'
                                : "Let's Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
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
