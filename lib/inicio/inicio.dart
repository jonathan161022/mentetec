import 'package:flutter/material.dart';
import 'package:flutter_mentetec/productos/productos.dart';
import 'package:flutter_mentetec/productos/proformas_list.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    const nombre = "Jessica";
    const apellido = "Montalvan";

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
              const Row(
                children: [
                  Text(
                    "$nombre $apellido.",
                    style: TextStyle(fontSize: 18),
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
          padding: const EdgeInsets.symmetric(vertical: 50),
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
                          width: 130, // Ancho del contenedor circular
                          height: 130, // Altura del contenedor circular
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
                          width: 130, // Ancho del contenedor circular
                          height: 130, // Altura del contenedor circular
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
                          padding: const EdgeInsets.only(
                              top: 30, right: 10, bottom: 10, left: 10),
                          width: 130, // Ancho del contenedor circular
                          height: 130, // Altura del contenedor circular
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
                              top: 30, right: 10, bottom: 10, left: 10),
                          width: 130, // Ancho del contenedor circular
                          height: 130, // Altura del contenedor circular
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
