import 'package:flutter/material.dart';
import 'package:flutter_mentetec/screens/clientes/clientes_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/productos.dart';
import '../screens/proformas_list.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  late SharedPreferences prefs;
  String nombre = '';
  String apellidos = '';

  Future<void> obtenerDatosUsuario() async {
    prefs = await SharedPreferences.getInstance();
    nombre = prefs.getString('nombre') ?? '';
    apellidos = prefs.getString('apellidos') ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    obtenerDatosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(context),
      bottomNavigationBar: Container(
        color: const Color(0xFF47B9EA),
        padding: const EdgeInsets.all(10),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Copyright © 2024 Mentetec. Todos los derechos reservados.',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              'Desarrollado por Mentetec',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bienvenido...",
                style: TextStyle(fontSize: 24, fontFamily: "fantasy"),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    "$nombre$apellidos",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "¿Qué vamos a hacer el día de hoy?...",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.withOpacity(0.5)),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
          color: Color(0xFF47B9EA),
          indent: 20,
          endIndent: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ClipOval(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 30, right: 10, bottom: 10, left: 10),
                          width: 110, // Ancho del contenedor circular
                          height: 110, // Altura del contenedor circular
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF47B9EA), // Color de fondo del contenedor
                            borderRadius: BorderRadius.circular(
                                50), // Radio igual a la mitad del ancho/alto para hacer un círculo
                          ),
                          child: Image.asset('assets/carrito.png'),
                        ),
                      ),
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Productos())),
                          child: const Text('PRODUCTOS',
                              style: TextStyle(color: Colors.black54)))
                    ],
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Column(
                    children: [
                      ClipOval(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, bottom: 20, left: 20),
                          width: 110, // Ancho del contenedor circular
                          height: 110, // Altura del contenedor circular
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF47B9EA), // Color de fondo del contenedor
                            borderRadius: BorderRadius.circular(
                                50), // Radio igual a la mitad del ancho/alto para hacer un círculo
                          ),
                          child: Image.asset('assets/pedidos.png'),
                        ),
                      ),
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProformasList())),
                          child: const Text('PEDIDOS',
                              style: TextStyle(color: Colors.black54)))
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ClipOval(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 110, // Ancho del contenedor circular
                          height: 110, // Altura del contenedor circular
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF47B9EA), // Color de fondo del contenedor
                            borderRadius: BorderRadius.circular(
                                50), // Radio igual a la mitad del ancho/alto para hacer un círculo
                          ),
                          child: Image.asset('assets/grupo.png'),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ClientesList()));
                          },
                          child: const Text('CLIENTES',
                              style: TextStyle(color: Colors.black54)))
                    ],
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Column(
                    children: [
                      ClipOval(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 30, right: 10, bottom: 10, left: 10),
                          width: 110, // Ancho del contenedor circular
                          height: 110, // Altura del contenedor circular
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF47B9EA), // Color de fondo del contenedor
                            borderRadius: BorderRadius.circular(
                                50), // Radio igual a la mitad del ancho/alto para hacer un círculo
                          ),
                          child: Image.asset('assets/carrito.png'),
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text('PEDIDOS',
                              style: TextStyle(color: Colors.black54)))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
