import 'package:flutter/material.dart';

class CustomStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF16154D), // Color para el título
  );

  static final ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
        Color(0xFF07ADF3)), // Color de fondo del botón
    textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(color: Colors.white)), // Color del texto del botón
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10), // Ajusta el radio según tu preferencia
      ),
    ),
  );
}
