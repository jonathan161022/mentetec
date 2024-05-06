import 'package:flutter/material.dart';
import 'package:flutter_mentetec/productos/productos.dart';
import 'package:flutter_mentetec/productos/proformas_list.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
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
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF47B9EA),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.ac_unit,
                          size: 125,
                          color: Colors.white,
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
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF47B9EA),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.ac_unit,
                          size: 125,
                          color: Colors.white,
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF47B9EA),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.adobe,
                          size: 125,
                          color: Colors.white,
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
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF47B9EA),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.ac_unit,
                          size: 125,
                          color: Colors.white,
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
        const SizedBox(
          height: 20,
        ),
        Container(
          color: const Color(0xFF47B9EA),
          padding: const EdgeInsets.all(10),
          child: const Column(
            children: [
              Text(
                'Copyright © 2024 Mentetec. Todos los derechos reservados.',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'Desarrollado por Mentetec',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }
}
