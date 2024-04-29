import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final nombre = "Jessica";
    final apellido = "Montalvan";

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bienvenido...",
                  style: TextStyle(fontSize: 24, fontFamily: "fantasy"),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "$nombre $apellido.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "¿Qué vamos a hacer el día de hoy?...",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Color(0xFF47B9EA),
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}
