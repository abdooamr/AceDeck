import 'package:AceDeck/Screens/GameMenu.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/cards3.jpg', // Replace with your image path
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 155.0),
          child: Center(
            child: isAnimating
                ? Lottie.asset(
                    'images/door2.json', // Replace with your Lottie animation path
                    height: 200,
                    repeat: false,
                    onLoaded: (composition) {
                      // Animation is ready.
                    },
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isAnimating = true;
                        });

                        // Simulate animation completion after a delay
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GameScreen(),
                            ),
                          );
                        });
                      },
                      icon: Icon(IconsaxBold.arrow_up_1),
                      label: Text('Play Game'),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
