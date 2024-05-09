import 'package:flutter_mentetec/model/model_producto.dart';

class Proforma {
  final int personaId;
  final String numero;
  final String nombreCliente;
  final String dniCliente;
  final String apellidoCliente;
  final int empresaId;
  final double subtotalCero;
  final double descuento;
  final double subtotal;
  final double iva;
  final double total;
  final List<Producto> productos;
  final String unidadNegocio;

  Proforma({
    required this.subtotalCero,
    required this.descuento,
    required this.subtotal,
    required this.iva,
    required this.dniCliente,
    required this.apellidoCliente,
    required this.personaId,
    required this.numero,
    required this.nombreCliente,
    required this.empresaId,
    required this.total,
    required this.productos,
    required this.unidadNegocio,
  });
}
