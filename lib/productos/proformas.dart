import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentetec/Login/styles.dart';
import 'package:provider/provider.dart';
import '../api/login_rest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login.dart';
import '../model/model_producto.dart';
import '../custom/custom_text_field.dart';

class CrearProforma extends StatefulWidget {
  final List<Producto> productosSeleccionados;

  const CrearProforma({super.key, required this.productosSeleccionados});

  @override
  _CrearProformaState createState() => _CrearProformaState();
}

class _CrearProformaState extends State<CrearProforma> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late List<int> cantidades;
  late List<double> preciosTotales;
  late double precioFinal;
  int personaId = 1;
  int empresaId = 1;
  final TextEditingController nombreCliente = TextEditingController();

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
    traerDatos();
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

  // Método para obtener datos del usuario desde SharedPreferences
  void traerDatos() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      // Llama a la función de inicio de sesión
      final response = await LoginRest.login(username, password);

      // Obtiene los datos de la respuesta
      String token = response.token;
      int idEmpresa = response.idEmpresa;
      String unidadNegocio = response.unidadNegocio;

      // Guarda los datos en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setInt('idEmpresa', idEmpresa);
      prefs.setString('unidadNegocio', unidadNegocio);
      final authToken = Provider.of<AuthToken>(context);
      String tokenG = authToken.token!;
      print(tokenG);
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener datos: $e');
      }
    }
  }

  // Método para guardar la proforma
  // Future<void> guardarProforma() async {
  //   try {
  //     // Obtener datos del usuario
  //     await traerDatos();
  //     String token =(await SharedPreferences.getInstance()).getString('token') ?? '';

  //     // Construir la proforma
  //     Map<String, dynamic> nuevaProforma = {
  //       'personaId': personaId,
  //       'nombreCliente': nombreCliente.text,
  //       'empresaId': empresaId,
  //       'total': precioFinal,
  //       'productosVenta': widget.productosSeleccionados.map((producto) {
  //         return {
  //           'cantidad': producto.cantidad,
  //           'precioTotal':
  //               precioFinal, // Corregir si el precio total es diferente por producto
  //           'inventarioId':
  //               producto.id, // Asegúrate de obtener el ID correcto del producto
  //           // Otros campos necesarios para el producto de venta
  //         };
  //       }).toList(),
  //       // Asegúrate de obtener 'unidadNegocio' del usuario si es necesario
  //     };

  //     // Realizar la solicitud HTTP para guardar la proforma
  //     await proformas.crearProforma(nuevaProforma, nombreCliente.text, token);
  //   } catch (error) {
  //     // Ocurrió un error al guardar la proforma
  //     // Muestra un mensaje de error al usuario o maneja el error según sea necesario
  //     if (kDebugMode) {
  //       print('Error al guardar la proforma: $error');
  //     }
  //   }
  // }

  Future<void> guardarProforma(String token) async {
    final proformaData = {
      "numero": "123",
      "personaId": 1,
      "nombreCliente": "Cliente Ejemplo",
      "total": 100.0,
      "productosVenta": [
        {"cantidad": 2, "precioTotal": 50.0, "inventarioId": 1},
        {"cantidad": 1, "precioTotal": 50.0, "inventarioId": 2}
      ]
    };
    // token = traerDatos();
    // if (token != null) {
    //   await guardarProforma(token);
    // }
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
            CustomTextField(
              controller: nombreCliente,
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
                  width: 60), // Agrega un espacio entre los elementos
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
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
