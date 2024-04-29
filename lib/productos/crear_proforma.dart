import 'package:flutter/material.dart';

import 'productos.dart';
import '../model/producto.dart';

class CrearProforma extends StatelessWidget {
  final List<Producto> productosSeleccionados;

  CrearProforma({Key? key, required this.productosSeleccionados})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Proforma'),
      ),
      body: ListView.builder(
        itemCount: productosSeleccionados.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(productosSeleccionados[index].nombre),
            subtitle: Text(
                'Descripción: ${productosSeleccionados[index].descripcion}'),
            trailing: Text(
                'Precio de venta: \$${productosSeleccionados[index].precioVenta.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
