import 'package:flutter/material.dart';
import 'Login/login.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: LoginForm(),
      ),
    ),
  );
}
