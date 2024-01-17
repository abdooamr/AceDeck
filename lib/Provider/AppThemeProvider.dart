import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  late Color _primaryColor = Colors.deepPurpleAccent;
  Color get primaryColor => _primaryColor;

  ThemeProvider() {
    _loadPrimaryColor();
  }

  void _loadPrimaryColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('primaryColor') ?? Colors.deepPurple.value;
    _primaryColor = Color(colorValue);
    notifyListeners();
  }

  void changePrimaryColor(Color newColor) async {
    _primaryColor = newColor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', newColor.value);
    notifyListeners();
  }
}

class ThemeDialog extends StatelessWidget {
  final List<Color> colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
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
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                height: 50,
                width: 50,
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
