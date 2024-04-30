import 'package:flutter_mentetec/model/model_producto.dart';

class CrearProforma {
  final int personaId;
  final String nombreCliente;
  final int empresaId;
  final double total;
  final List<Producto> productos;
  final String unidadNegocio;

  CrearProforma({
    required this.personaId,
    required this.nombreCliente,
    required this.empresaId,
    required this.total,
    required this.productos,
    required this.unidadNegocio,
  });
}
