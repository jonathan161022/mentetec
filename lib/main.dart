import 'package:flutter/material.dart';
import 'Login/login.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: LoginForm(),
      ),
    ),
  );
}
