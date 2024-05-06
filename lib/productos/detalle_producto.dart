import 'package:flutter/material.dart';

import '../model/model_producto.dart';

class DetalleProducto extends StatelessWidget {
  final Producto producto;
   final String imageUrl;

  const DetalleProducto({super.key, required this.producto, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Nombre: ${producto.nombre}', style: TextStyle(fontSize: 30),),
            Text('Descripción: ${producto.descripcion}'),
            Text('Precio de Venta: \$${producto.precioVenta.toStringAsFixed(2)}'),
            imageUrl.isNotEmpty
                ? Image.network(imageUrl) // Si hay una URL de imagen, muestra la imagen
                : const Placeholder(), // Muestra un Placeholder si no hay una URL de imagen
            // Agrega aquí más detalles del producto según tus necesidades
            // Agrega aquí más detalles del producto según tus necesidades
          ],
        ),
      ),
    );
  }
}
