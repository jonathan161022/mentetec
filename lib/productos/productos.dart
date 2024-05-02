import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentetec/model/model_producto.dart';
import 'package:flutter_mentetec/productos/proformas_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Producto> listaProductos = [];
  List<Producto> productosSeleccionados = [];
  String filtro = 'nombre'; // Inicialmente busca por nombre
  int pageInit = 0;
  int pageEnd = 5;
  late SharedPreferences prefs;
  int empresaId = 0;
  String unidadNegocio = '';
  String token = '';
  String valor = '';
  List<Producto> productosFiltrados = [];
  List<Opcion> menu = [
    Opcion(nombre: 'Realizar Pedido'),
    Opcion(nombre: 'Mis Proformas'),
  ];
  final TextEditingController _searchController =
      TextEditingController(); // Agrega el controlador de texto para el buscador

  void onSearchTextChanged(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        // Si el texto de búsqueda está vacío, restaura la lista completa
        productosFiltrados = listaProductos;
      } else {
        // Filtra la lista de productos por el texto de búsqueda
        cargarProductos();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: 2, vsync: this);
    obtenerDatosUsuario();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> obtenerDatosUsuario() async {
    prefs = await SharedPreferences.getInstance();
    empresaId = prefs.getInt('idEmpresa') ?? 0;
    unidadNegocio = prefs.getString('unidadNegocio') ?? '';
    token = prefs.getString('token') ?? '';
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    valor = _searchController.text;

    try {
      final response = await obtenerTodosProductos(
          0, 5, token, filtro, valor, empresaId, unidadNegocio);
      final List<dynamic> productosResponse = jsonDecode(response.body)['data'];
      final List<Producto> productos = [];
      List<String> nombresImagenes = [];

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

        productos.add(producto);
        nombresImagenes.add(producto.nombreImagen);
      }

      setState(() {
        listaProductos = productos;
        productosFiltrados = productos; // Inicializa la lista filtrada
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
    for (String nombreImagen in nombresImagenes) {
      try {
        final imagenData = await obtenerImagenes(token, nombreImagen);
        final imagen = MemoryImage(imagenData!);
        imagenesProductos.add(imagen);
      } catch (error) {
        // Si hay un error al cargar la imagen, añadir una imagen predeterminada
        imagenesProductos
            .add(const AssetImage('assets/imagen_predeterminada.jpg'));
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
    return productosSeleccionados;
  }

  Future<void> _mostrarDialogo(BuildContext context) async {
    List<Producto> productosSeleccionados =
        obtenerProductosSeleccionados(listaProductos);

    if (productosSeleccionados.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: const Text('Por favor, selecciona al menos un producto.'),
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
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return DialogoCrearProforma(
              productosSeleccionados: productosSeleccionados);
        },
      );
    }
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
              _mostrarDialogo(context);
            } else if (value == 'Mis Proformas') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProformasList()),
              );
            }
          }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(
                15.0), // Ajusta el margen según tus necesidades
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: onSearchTextChanged,
                    decoration: InputDecoration(
                      labelText: 'Buscar por $filtro',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.tune),
                        onPressed: () {
                          // Implementa la lógica para abrir el menú de filtros
                          mostrarMenuFiltro(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _handlePageViewChanged,
              itemCount: (productosFiltrados.length / 5).ceil(),
              itemBuilder: (context, index) {
                return _buildProductPage(index);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
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

  void mostrarMenuFiltro(BuildContext context) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(
        0.0,
        0.0,
        0.0,
        0.0,
      ),
      items: [
        const PopupMenuItem<String>(
          value: 'nombre',
          child: Text('Nombre'),
        ),
        const PopupMenuItem<String>(
          value: 'descripcion',
          child: Text('Descripción'),
        ),
        const PopupMenuItem<String>(
          value: 'cantidad',
          child: Text('Cantidad'),
        ),
        const PopupMenuItem<String>(
          value: 'codigo',
          child: Text('Código'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          filtro = value;
        });
      }
    });
  }

  Widget _buildProductPage(int pageIndex) {
    final startIndex = pageIndex * 5;
    final endIndex = startIndex + 5;
    final pageProductos = productosFiltrados.sublist(
        startIndex,
        endIndex < productosFiltrados.length
            ? endIndex
            : productosFiltrados.length);

    return ListView.separated(
      itemCount: pageProductos.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 10,
      ), // Separador entre elementos
      itemBuilder: (context, index) {
        return _buildProductItem(pageProductos[index]);
      },
    );
  }

  Widget _buildProductItem(Producto producto) {
    return ClipRRect(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(241, 241, 241, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(producto.nombre),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(producto.descripcion),
              Text(
                '\$${producto.precioVenta.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          leading: producto.imagen != null
              ? Image(image: producto.imagen!)
              : Image.asset('assets/imagen_predeterminada.jpg'),
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
              });
            },
          ),
        ),
      ),
    );
  }
}

class DialogoCrearProforma extends StatefulWidget {
  final List<Producto> productosSeleccionados;

  const DialogoCrearProforma({super.key, required this.productosSeleccionados});

  @override
  State<DialogoCrearProforma> createState() => _DialogoCrearProformaState();
}

class _DialogoCrearProformaState extends State<DialogoCrearProforma> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: SizedBox(
        height: MediaQuery.of(context).size.height, // Tamaño de la pantalla
        width: MediaQuery.of(context).size.width, // Tamaño de la pantalla
        child: CrearProforma(
            productosSeleccionados: widget.productosSeleccionados),
      ),
    );
  }
}
