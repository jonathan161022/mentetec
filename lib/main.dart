import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login/login.dart';


void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthToken(), // Crear una instancia de AuthToken
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: LoginForm(),
        ),
      ),
    );
  }
}