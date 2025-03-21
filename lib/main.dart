import 'package:flutter/material.dart';
import 'package:perfil_viajante/screens/user_settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perfil Viajante',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 31, 156, 15)),
      ),
      home: UserSettingsScreen(),
    );
  }
}