import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/styles.dart';
import '../model/model_producto.dart';
import '../custom/custom_text_field.dart';

class CrearProforma extends StatefulWidget {
  final List<Producto> productosSeleccionados;

  CrearProforma({Key? key, required this.productosSeleccionados})
      : super(key: key);

  @override
  _CrearProformaState createState() => _CrearProformaState();
}

class _CrearProformaState extends State<CrearProforma> {
  late List<int> cantidades;
  late List<double> preciosTotales;
  late double precioFinal;
  int personaId = 1;
  int empresaId = 1;
  final TextEditingController nombreCliente = TextEditingController();

  @override
  void initState() {
    super.initState();
    cantidades = List<int>.filled(widget.productosSeleccionados.length, 1);
    preciosTotales =
        List<double>.filled(widget.productosSeleccionados.length, 0.0);
    precioFinal = 0.0;

    // Calcular precios totales iniciales basados en los precios de venta
    for (int i = 0; i < widget.productosSeleccionados.length; i++) {
      double precioUnitario = widget.productosSeleccionados[i].precioVenta;
      int cantidad = cantidades[i];
      preciosTotales[i] = precioUnitario * cantidad;
    }

    calcularPrecioFinal(); // Calcular el precio final inicial
  }

  void actualizarCantidad(int index, int nuevaCantidad) {
    setState(() {
      cantidades[index] = nuevaCantidad;
      calcularPrecioTotal(index);
      calcularPrecioFinal();
    });
  }

  void calcularPrecioTotal(int index) {
    double precioUnitario = widget.productosSeleccionados[index].precioVenta;
    int cantidad = cantidades[index];
    double precioTotal = precioUnitario;
    precioTotal = precioUnitario * cantidad;
    preciosTotales[index] = precioTotal;
  }

  void calcularPrecioFinal() {
    precioFinal = preciosTotales.reduce((a, b) => a + b);
  }
    Future<void> traerDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int empresaId = prefs.getInt('idEmpresa') ?? 0;
    String unidadNegocio = prefs.getString('unidadNegocio') ?? '';
    String token = prefs.getString('token') ?? '';
  // guardarProforma(empresaId, unidadNegocio, token);
  

  }


  // void guardarProforma(int empresaId, String unidadNegocio, String token) async {
    
  //   Map<String, dynamic> nuevaProforma = {
  //     'personaId': personaId,
  //     'nombreCliente': nombreCliente,
  //     'empresaId': empresaId,
  //     'total': precioFinal,
  //     'productosVenta':[{
  //       'inventarioId': 
  //     }], // Utiliza la lista de productos seleccionados
  //     'unidadNegocio': unidadNegocio,
  //   };

  //   try {
  //     // Llama a la función de inicio de sesión
  //     final response = await pro.crearProforma(nuevaProforma, token);

  //     // Obtiene los datos de la respuesta
  //     String token = response.token;
  //     int idEmpresa = response.idEmpresa;
  //     String unidadNegocio = response.unidadNegocio;

  //     //Diseño
  //     String colorBase = response.colorBase;

  //     // Guarda los datos en SharedPreferences
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString('token', token);
  //     prefs.setInt('idEmpresa', idEmpresa);
  //     prefs.setString('unidadNegocio', unidadNegocio);

  //     // Navega a la pantalla de Dashboard
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => Dashboard()),
  //     );
  //   } catch (e) {
  //     print('Error al iniciar sesión: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Proforma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: nombreCliente,
              labelText: 'Nombre Cliente:',
              // hintText: 'Ingrese su usuario',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese su usuario';
                }
                return null;
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.productosSeleccionados.length,
                itemBuilder: (context, index) {
                  Producto producto = widget.productosSeleccionados[index];
                  int cantidad = cantidades[index];
                  double precioTotal = preciosTotales[index];

                  return ListTile(
                    title: Text(producto.nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Precio Unitario: \$${producto.precioVenta.toStringAsFixed(2)}'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (cantidad > 1) {
                                  actualizarCantidad(index, cantidad - 1);
                                }
                              },
                            ),
                            Text('$cantidad'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                actualizarCantidad(index, cantidad + 1);
                              },
                            ),
                          ],
                        ),
                        Text(
                            'Precio Total: \$${precioTotal.toStringAsFixed(2)}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Text(
                'Total: \$${precioFinal.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                  width: 60), // Agrega un espacio entre los elementos
              Expanded(
                // Agrega Expanded alrededor del botón
                child: ElevatedButton(
                  onPressed: () {},
                  style: CustomStyles.buttonStyle,
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
