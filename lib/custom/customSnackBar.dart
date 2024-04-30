import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackbar(context, message), // Pasar el BuildContext como argumento
    );
  }

  static SnackBar _buildSnackbar(BuildContext context, String message) {
    return SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(message),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
    );
  }
}

