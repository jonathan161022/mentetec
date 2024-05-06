import 'package:flutter_mentetec/model/model_producto.dart';

class Proforma {
  final int personaId;
  final String numero;
  final String nombreCliente;
  final int empresaId;
  final double total;
  final List<Producto> productos;
  final String unidadNegocio;

  Proforma({
    required this.personaId,
    required this.numero,
    required this.nombreCliente,
    required this.empresaId,
    required this.total,
    required this.productos,
    required this.unidadNegocio,
  });
}
