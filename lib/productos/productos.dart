import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentetec/model/model_producto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import '../api/imagenes_rest.dart';
import '../api/productos_rest.dart';
import 'proformas.dart';

class Opcion {
  final String nombre;

  Opcion({
    required this.nombre,
  });
}

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<Productos> with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  late List<Producto> listaProductos = [];
  List<Producto> productosSeleccionados = [];
  List<Opcion> menu = [
    Opcion(nombre: 'Realizar Pedido'),
    Opcion(nombre: 'Opcion 2'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: 2, vsync: this);
    obtenerDatosUsuario();
    // obtenerTodosProductos(
    //         1,
    //         5,
    //         'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMTUwNjYyMDk0IiwiaWF0IjoxNzE0MzQ5OTY1LCJleHAiOjE3MTQzNzg3NjV9.EEBiv52kr8e3ZIEUnKzvpeg9su51YaCaSieXoBhBi10',
    //         'codigo',
    //         'TC',
    //         1,
    //         'c328e550-92b0-11ee-b9d1-0242ac120002')
    //     .then((response) {
    //   if (response.statusCode == 200) {
    //     // La solicitud fue exitosa
    //     var jsonResponse = jsonDecode(response.body);
    //     print(jsonResponse); // Muestra el contenido de la respuesta
    //   } else {
    //     // La solicitud falló con un código de estado diferente a 200
    //     print('Error: ${response.reasonPhrase}');
    //   }
    // });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> obtenerDatosUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int empresaId = prefs.getInt('idEmpresa') ?? 0;
    String unidadNegocio = prefs.getString('unidadNegocio') ?? '';
    String token = prefs.getString('token') ?? '';
    String filtro = '';
    String valor = '';
    await cargarProductos(empresaId, unidadNegocio, token, filtro, valor);
  }

  Future<void> cargarProductos(int empresaId, String unidadNegocio,
      String token, String filtro, String valor) async {
    try {
      final response = await obtenerTodosProductos(
          0, 5, token, filtro, valor, empresaId, unidadNegocio);
      final List<dynamic> productosResponse = jsonDecode(response.body)['data'];
      final List<Producto> productos = [];
      List<String> nombresImagenes = [];

      // Obtener la imagen predeterminada
      ImageProvider imagenPredeterminada =
          const AssetImage('assets/imagen_predeterminada.jpg');

      for (dynamic productoData in productosResponse) {
        Producto producto = Producto(
          id: productoData['id'],
          codigo: productoData['codigo'] ?? '',
          nombre: productoData['nombre'] ?? '',
          descripcion: productoData['descripcion'] ?? '',
          cantidad: productoData['cantidad'] ?? 0,
          precioCompra: (productoData['precioCompra'] ?? 0.0),
          precioVenta: (productoData['precioVenta'] ?? 0.0),
          imagen: null,
          nombreImagen: productoData['imagen'] ?? '',
          isChecked: false,
        );

        // Verificar si la imagen está vacía y asignar la imagen predeterminada
        if (producto.nombreImagen.isEmpty) {
          producto.imagen = imagenPredeterminada;
        }

        productos.add(producto);
        nombresImagenes.add(producto.nombreImagen);
        if (kDebugMode) {
          print("Img1$nombresImagenes");
        }
      }

      setState(() {
        listaProductos = productos;
      });

      List<ImageProvider> imagenesProductos =
          await cargarImagenes(token, nombresImagenes);

      for (int i = 0; i < listaProductos.length; i++) {
        listaProductos[i].imagen = imagenesProductos[i];
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error al cargar productos: $error');
      }
    }
  }

  Future<List<ImageProvider>> cargarImagenes(
      String token, List<String> nombresImagenes) async {
    List<ImageProvider> imagenesProductos = [];
    try {
      for (String nombreImagen in nombresImagenes) {
        final imagenData = await obtenerImagenes(token, nombreImagen);
        final imagenBytes = Uint8List.fromList(imagenData);
        final imagen = MemoryImage(imagenBytes);
        imagenesProductos.add(imagen);
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error al cargar la imagen: $error");
      }
    }
    return imagenesProductos;
  }

  List<Producto> obtenerProductosSeleccionados(List<Producto> listaProductos) {
    List<Producto> productosSeleccionados = [];
    for (Producto producto in listaProductos) {
      if (producto.isChecked) {
        productosSeleccionados.add(producto);
      }
    }
    if (kDebugMode) {
      print("Lista de productos seleccionados: $productosSeleccionados");
    }
    return productosSeleccionados;
  }

  Future<void> _mostrarDialogo(BuildContext context) async {
    List<Producto> productosSeleccionados =
        obtenerProductosSeleccionados(listaProductos);

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DialogoCrearProforma(
            productosSeleccionados: productosSeleccionados);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return menu.map((opcion) {
              return PopupMenuItem(
                value: opcion.nombre,
                child: Text(opcion.nombre),
              );
            }).toList();
          }, onSelected: (value) async {
            if (value == 'Realizar Pedido') {
              // Obtener la lista de productos seleccionados
              // List<Producto> productosSeleccionados =
              //     obtenerProductosSeleccionados(listaProductos);
              // // Navegar a la pantalla CrearProformaScreen y pasar la lista de productos seleccionados
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     // Pasa la lista de productos seleccionados como parámetro al constructor de CrearProformaScreen
              //     builder: (context) => CrearProforma(
              //         productosSeleccionados: productosSeleccionados),
              //   ),
              // );
              _mostrarDialogo(context);
            }
          }),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _handlePageViewChanged,
            itemCount: (listaProductos.length / 5).ceil(),
            itemBuilder: (context, index) {
              return _buildProductPage(index);
            },
          ),
          Positioned(
            bottom: 10,
            left: 5,
            right: 5,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      if (_pageController.page!.toInt() > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                  ),
                  TabPageSelector(
                    controller: _tabController,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      if (_pageController.page!.toInt() <
                          (listaProductos.length / 5).ceil() - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    _tabController.index = currentPageIndex;
    setState(() {});
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  Widget _buildProductPage(int pageIndex) {
    final startIndex = pageIndex * 5;
    final endIndex = startIndex + 5;
    final pageProductos = listaProductos.sublist(startIndex,
        endIndex < listaProductos.length ? endIndex : listaProductos.length);

    return ListView.separated(
      itemCount: pageProductos.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(), // Separador entre elementos
      itemBuilder: (context, index) {
        return _buildProductItem(pageProductos[index]);
      },
    );
  }

  Widget _buildProductItem(Producto producto) {
    ImageProvider imagenPredeterminada =
        const AssetImage('assets/imagen_predeterminada.jpg');

    Color backgroundColor = Colors.grey;

    // Obtener el color de fondo

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ListTile(
        title: Text(producto.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(producto.descripcion),
            Text(
                'Precio de venta: \$${producto.precioVenta.toStringAsFixed(2)}'),
          ],
        ),
        leading: producto.imagen != null
            ? Image(image: producto.imagen!)
            : Image(image: imagenPredeterminada),
        trailing: Checkbox(
          shape: const CircleBorder(),
          value: producto.isChecked,
          onChanged: (bool? value) {
            setState(() {
              producto.isChecked = value ?? false;
              if (producto.isChecked) {
                // Agregar el producto a la lista de productos seleccionados
                productosSeleccionados.add(producto);
              } else {
                // Eliminar el producto de la lista de productos seleccionados
                productosSeleccionados.remove(producto);
              }
              if (kDebugMode) {
                print(productosSeleccionados.toString());
              }
            });
          },
        ),
      ),
    );
  }
}

class DialogoCrearProforma extends StatelessWidget {
  final List<Producto> productosSeleccionados;

  DialogoCrearProforma({required this.productosSeleccionados});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: SizedBox(
        height: MediaQuery.of(context).size.height, // Tamaño de la pantalla
        width: MediaQuery.of(context).size.width, // Tamaño de la pantalla
        child: CrearProforma(productosSeleccionados: productosSeleccionados),
      ),
    );
  }
}
