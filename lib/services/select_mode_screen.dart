import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectModeScreen extends StatefulWidget {
  const SelectModeScreen({Key? key}) : super(key: key);

  @override
  _SelectModeScreenState createState() => _SelectModeScreenState();
}

class _SelectModeScreenState extends State<SelectModeScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    setState(() {
      _themeMode = ThemeMode.values[themeModeIndex];
    });
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Light Mode'),
            leading: Radio(
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (value) => _saveThemeMode(value as ThemeMode),
            ),
            onTap: () => _saveThemeMode(ThemeMode.light),
          ),
          ListTile(
            title: const Text('Dark Mode'),
            leading: Radio(
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (value) => _saveThemeMode(value as ThemeMode),
            ),
            onTap: () => _saveThemeMode(ThemeMode.dark),
          ),
          ListTile(
            title: const Text('System Default'),
            leading: Radio(
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) => _saveThemeMode(value as ThemeMode),
            ),
            onTap: () => _saveThemeMode(ThemeMode.system),
          ),
        ],
      ),
    );
  }
}