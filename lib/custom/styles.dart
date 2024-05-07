import 'package:flutter/material.dart';

class CustomStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF), // Color para el título
  );

  static final ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0xFF07ADF3)), // Color de fondo del botón
    textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(color: Colors.white)), // Color del texto del botón
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Ajusta el radio según tu preferencia
      ),
    ),
  );
}
