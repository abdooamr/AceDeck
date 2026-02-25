// import 'package:AceDeck/Provider/AppThemeProvider.dart';
// import 'package:AceDeck/Screens/GameMenu.dart';
// import 'package:ficonsax/ficonsax.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AppDrawer extends StatefulWidget {
//   final Function onNewGame;

//   AppDrawer({required this.onNewGame});

//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, _) {
//         return Drawer(
//           child: Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                     'images/cards.jpg'), // Replace with your image path
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: <Widget>[
//                 SizedBox(height: 20),
//                 ListTile(
//                   leading: Icon(
//                     Icons.home,
//                     color: Colors.blue,
//                   ),
//                   title: Text(
//                     'Home',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontSize: 20,
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => GameScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 Divider(
//                   color: Colors.grey,
//                   thickness: 1,
//                   height: 1,
//                 ),
//                 ListTile(
//                   leading: Icon(
//                     IconsaxBold.game,
//                     color: Colors.green,
//                   ),
//                   title: Text(
//                     'New Game',
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 20,
//                     ),
//                   ),
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Image.asset(
//                                 'images/giphy.gif', // Replace with your fancy GIF
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );

//                     Future.delayed(Duration(seconds: 2), () {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                       widget.onNewGame();
//                     });
//                   },
//                 ),
//                 // Add more list items or customizations as needed
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
