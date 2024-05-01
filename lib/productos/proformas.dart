import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mentetec/Login/styles.dart';
import 'package:flutter_mentetec/custom/customSnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model_producto.dart';
import '../custom/custom_text_field.dart';
import '../api/proformas_rest.dart' as proformaRest;

class CrearProforma extends StatefulWidget {
  final List<Producto> productosSeleccionados;

  const CrearProforma({super.key, required this.productosSeleccionados});

  @override
  _CrearProformaState createState() => _CrearProformaState();
}

class _CrearProformaState extends State<CrearProforma> {
  late List<int> cantidades;
  late List<double> preciosTotales;
  late double precioFinal;
  int personaId = 1;
  int empresaId = 1;
  final TextEditingController _nombreCliente = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialización de las listas de cantidades y precios totales
    cantidades = List<int>.filled(widget.productosSeleccionados.length, 1);
    preciosTotales =
        List<double>.filled(widget.productosSeleccionados.length, 0.0);
    precioFinal = 0.0;

    // Cálculo de precios totales iniciales basados en los precios de venta
    for (int i = 0; i < widget.productosSeleccionados.length; i++) {
      double precioUnitario = widget.productosSeleccionados[i].precioVenta;
      int cantidad = cantidades[i];
      preciosTotales[i] = precioUnitario * cantidad;
    }

    calcularPrecioFinal(); // Cálculo del precio final inicial
  }

  // Método para actualizar la cantidad de un producto
  String actualizarCantidad(int index, int nuevaCantidad) {
    setState(() {
      cantidades[index] = nuevaCantidad;
      calcularPrecioTotal(index);
      calcularPrecioFinal();
    });

    // Devuelve la cantidad actualizada como un String
    return cantidades[index].toString();
  }

  // Método para calcular el precio total de un producto
  void calcularPrecioTotal(int index) {
    double precioUnitario = widget.productosSeleccionados[index].precioVenta;
    int cantidad = cantidades[index];
    double precioTotal = precioUnitario * cantidad;
    preciosTotales[index] = precioTotal;
  }

  // Método para calcular el precio final de la proforma
  void calcularPrecioFinal() {
    precioFinal = preciosTotales.reduce((a, b) => a + b);
  }

  Future<void> guardarProforma() async {
    String token =
        (await SharedPreferences.getInstance()).getString('token') ?? '';
    String unidadNegocio =
        (await SharedPreferences.getInstance()).getString('unidadNegocio') ??
            '';
    int empresaId =
        (await SharedPreferences.getInstance()).getInt('empresaId') ?? 1;

    String nombreCliente = _nombreCliente.text;

    // Obtener los datos de cada producto en la lista productosSeleccionados
    List<Map<String, dynamic>> productosVenta = [];
    for (int i = 0; i < widget.productosSeleccionados.length; i++) {
      Producto producto = widget.productosSeleccionados[i];
      int cantidad = cantidades[i];
      double precioTotal = preciosTotales[i];

      productosVenta.add({
        'cantidad': cantidad,
        'precioUnitario': producto.precioVenta,
        'precioTotal': precioTotal,
        'inventarioId': producto.id,
        'unidadNegocio': unidadNegocio,
      });
    }

    final proformaData = {
      'numero': '001-001-000000049',
      'nombreCliente': nombreCliente,
      'personaRegistroId': 1,
      'personaVendedorId': 1,
      'total': precioFinal,
      'productosVenta': productosVenta,
      'empresaId': empresaId,
      'unidadNegocio': unidadNegocio
    };
    String? mensajeError = Validaciones.validarNombreCliente(nombreCliente);
    if (mensajeError != null) {
      // Mostrar mensaje de error si el nombre del cliente no es válido
      CustomSnackbar.show(context, mensajeError);
      return; // Salir del método si la validación falla
    }
    try {
      final response = await proformaRest.crearProforma(proformaData, token);
      // Convertir el cuerpo de la respuesta JSON en un Map
      // Map<String, dynamic> responseData = jsonDecode(response.body);

      // // Acceder al campo 'mensaje' en el Map
      // String mensaje = responseData['mensaje'];

      // CustomSnackbar.show(context, mensaje);
      Navigator.of(context).pop();
      mostrarDialogGuardar(context);
    } catch (e) {
      CustomSnackbar.show(context, 'Error al registrar.');
    }
  }

  Future<void> mostrarDialogGuardar(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Proforma guardada correctamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Proforma'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          
          children: [
            const Text('Nro. Pedido: '),
            CustomTextField(
              controller: _nombreCliente,
              labelText: 'Nombre Cliente:',

              // Añadir validación si es necesario
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                itemCount: widget.productosSeleccionados.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ), // Separador personalizado entre elementos
                itemBuilder: (context, index) {
                  Producto producto = widget.productosSeleccionados[index];
                  int cantidad = cantidades[index];
                  double precioTotal = preciosTotales[index];

                  return ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // Radio de borde redondeado
                    child: Container(
                      color: Colors.grey[
                          100], // Color de fondo deseado para cada elemento
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto.nombre,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(producto.descripcion),
                                const SizedBox(height: 5),
                                Text(
                                  '\$${precioTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: IconButton(
                                  color: Colors.grey[400],
                                  iconSize: 35,
                                  icon:
                                      const Icon(Icons.remove_circle_outlined),
                                  onPressed: () {
                                    if (cantidad > 1) {
                                      actualizarCantidad(index, cantidad - 1);
                                    }
                                  },
                                ),
                              ),
                              Text('$cantidad'),
                              IconButton(
                                color: Colors.grey[400],
                                iconSize: 35,
                                icon: const Icon(Icons.add_circle_outlined),
                                onPressed: () {
                                  actualizarCantidad(index, cantidad + 1);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Text(
                'Total: \$${precioFinal.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 99, 99, 99)),
              ),
              const SizedBox(
                  width: 20), // Agrega un espacio entre los elementos
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    guardarProforma();
                    // Llama al método para guardar la proforma
                  },
                  style: CustomStyles.buttonStyle,
                  child: const Text('Guardar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Validaciones {
  static String? validarNombreCliente(String nombreCliente) {
    if (nombreCliente.isEmpty) {
      return 'El nombre del cliente no puede estar vacío';
    }
    return null; // Si la validación es exitosa, devuelve null
  }
}
