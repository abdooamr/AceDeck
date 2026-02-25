import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  late Color _primaryColor = Colors.deepPurpleAccent;
  Color get primaryColor => _primaryColor;
  bool _isDarkMode = true;
  bool _isGradient = false;

  bool get isDarkMode => _isDarkMode;
  bool get isGradient => _isGradient;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    // Save the theme preference to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    notifyListeners();
  }

  ThemeProvider() {
    _loadPrimaryColor();
    _loadTheme();
  }

  void _loadPrimaryColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue =
        prefs.getInt('primaryColor') ?? Colors.deepPurpleAccent.toARGB32();
    _primaryColor = Color(colorValue);
    notifyListeners();
  }

  void changePrimaryColor(Color newColor) async {
    _primaryColor = newColor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', newColor.toARGB32());
    notifyListeners();
  }
}

class ThemeDialog extends StatelessWidget {
  final List<Color> colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.deepOrange,
    Colors.blueGrey,
    Colors.cyan
  ];

  @override
  Widget build(BuildContext context) {
    Color currentColor = Provider.of<ThemeProvider>(context).primaryColor;

    return AlertDialog(
      title: Text('Choose App Theme Color'),
      content: Container(
        width: double.maxFinite,
        child: GridView.count(
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: colorOptions.map((color) {
            bool isSelected = color == currentColor;
            return GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changePrimaryColor(color);
                // Navigator.pop(context); // Close the dialog
              },
              child: Container(
                height: 50,
                width: 50,
                child: Text(
                  getColorName(color),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "BlackOpsOne",
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Color.fromARGB(255, 3, 236, 170)
                        : Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: isSelected
                        ? Color.fromARGB(255, 3, 236, 170)
                        : Colors.transparent,
                    width: 3.0,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

String getColorName(Color color) {
  // You can implement a logic to get the color name based on the color value.
  // For simplicity, using a basic mapping for demonstration purposes.
  Map<Color, String> colorNames = {
    Colors.red: 'Red',
    Colors.blue: 'Blue',
    Colors.green: 'Green',
    Colors.orange: 'Orange',
    Colors.deepPurpleAccent: 'Purple',
    Colors.yellow: 'Yellow',
    Colors.teal: 'Teal',
    Colors.pink: 'Pink',
    Colors.indigo: 'Indigo',
    Colors.deepOrange: 'Deep Orange',
    Colors.blueGrey: 'Blue Grey',
    Colors.cyan: 'Cyan',
  };

  return colorNames[color] ?? 'Unknown';
}
