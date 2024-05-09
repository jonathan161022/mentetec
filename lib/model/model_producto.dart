import 'package:flutter/material.dart';

class Producto {
  final int id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final double cantidad;
  final double precioCompra;
  final double precioVenta;
  ImageProvider? imagen;
  final String nombreImagen;

  bool isChecked;
  bool tieneIva; // Nuevo atributo para almacenar el estado del checkbox

  Producto({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.precioCompra,
    required this.precioVenta,
    this.imagen,
    required this.nombreImagen,
    this.isChecked = false,
    this.tieneIva = false, // Valor predeterminado del estado del checkbox
  });

  @override
  String toString() {
    return 'Producto{codigo: $codigo, nombre: $nombre, descripcion: $descripcion, cantidad: $cantidad, precioCompra: $precioCompra, precioVenta: $precioVenta, imagen: $imagen, nombreImagen: $nombreImagen, isChecked: $isChecked}';
  }
}
