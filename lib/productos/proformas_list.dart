import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentetec/api/proformas_rest.dart';
import 'package:flutter_mentetec/model/model_producto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model_proforma.dart';

class ProformasList extends StatefulWidget {
  const ProformasList({super.key});

  @override
  State<ProformasList> createState() => _ProformasListState();
}

class _ProformasListState extends State<ProformasList>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  String filtro = 'nombreCliente'; // Inicialmente busca por nombre
  int pageInit = 0;
  int pageEnd = 5;
  late SharedPreferences prefs;
  int empresaId = 0;
  String unidadNegocio = '';
  String token = '';
  String valor = '';
  List<Proforma> listaProformas = [];
  List<Proforma> proformasFiltrados = [];

  final TextEditingController _searchProforma =
      TextEditingController(); // Agrega el controlador de texto para el buscador

  void onSearchTextChanged(String searchText) {
    cargarProformas(searchText: searchText);
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
          value: 'nombreCliente',
          child: Text('Nombre de Cliente'),
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

  Future<void> cargarProformas({String? searchText}) async {
    valor = searchText ?? _searchProforma.text;

    try {
      final response = await obtenerTodasProformas(
          0, 5, token, filtro, valor, empresaId, unidadNegocio);
      final List<dynamic> proformaResponse = jsonDecode(response.body)['data'];

      final List<Proforma> proformas = [];

      for (dynamic proformaData in proformaResponse) {
        List<dynamic> proformasData = proformaData['productosVenta'];
        List<Producto> productosList = proformasData
            .map((data) => Producto(
                  // Mapea los datos de cada producto a objetos Producto
                  id: data['id'],
                  codigo: data['inventario']['codigo'] ??
                      '', // Accede a 'codigo' dentro de 'inventario'
                  nombre: data['inventario']['nombre'] ??
                      '', // Accede a 'nombre' dentro de 'inventario'
                  descripcion: data['inventario']['descripcion'] ?? '',
                  cantidad: data['cantidad'] ?? 0,
                  precioCompra: (data['precioCompra'] ?? 0.0),
                  precioVenta: (data['inventario']['precioVenta'] ?? 0.0),
                  imagen: null,
                  nombreImagen: data['imagen'] ?? '',
                  isChecked: false,
                  // Agrega las propiedades necesarias según tu clase Producto
                ))
            .toList();
        Proforma proforma = Proforma(
          personaId: proformaData['personaId'] ?? 0,
          numero: proformaData['numero'] ?? '',
          nombreCliente: proformaData['nombreCliente'] ?? '',
          empresaId: proformaData['empresaId'] ?? 0,
          unidadNegocio: proformaData['unidadNegocio'] ?? '',
          productos: productosList,
          total: (proformaData['total'] ?? 0.0),
        );

        proformas.add(proforma);
      }

      setState(() {
        listaProformas = proformas;
        proformasFiltrados = proformas
            .where((proforma) =>
                proforma.nombreCliente
                    .toLowerCase()
                    .contains(valor.toLowerCase()) ||
                proforma.numero.toLowerCase().contains(valor.toLowerCase()))
            .toList();
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error al cargar las proformas: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Retrocede a la pantalla anterior
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(
                  15.0), // Ajusta el margen según tus necesidades
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchProforma,
                      onChanged: onSearchTextChanged,
                      decoration: const InputDecoration(
                        labelText: 'Buscar',
                        border: OutlineInputBorder(),
                        // suffixIcon: IconButton(
                        //   icon: const Icon(Icons.tune),
                        //   onPressed: () {
                        //     // Implementa la lógica para abrir el menú de filtros
                        //     mostrarMenuFiltro(context);
                        //   },
                        // ),
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
                itemCount: (proformasFiltrados.length / 5).ceil(),
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
                          (listaProformas.length / 5).ceil() - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.ease,
                        );
                        _tabController.index =
                            _pageController.page!.toInt() + 1;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: 2, vsync: this);

    obtenerDatosUsuario();
  }

  int calculatePageCount() {
    // Calcula la cantidad de páginas necesarias según la cantidad de productos filtrados
    int itemsPerPage =
        5; // Cambia esto según cuántos productos quieres mostrar por página
    return (proformasFiltrados.length / itemsPerPage).ceil();
  }

  Future<void> obtenerDatosUsuario() async {
    prefs = await SharedPreferences.getInstance();
    empresaId = prefs.getInt('idEmpresa') ?? 0;
    unidadNegocio = prefs.getString('unidadNegocio') ?? '';
    token = prefs.getString('token') ?? '';
    cargarProformas();
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

  Widget _buildProductItem(Proforma proforma) {
    return ClipRRect(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(
              'Número: ${proforma.numero.toString()}',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(proforma.nombreCliente),
                Text('Total: ${proforma.total.toString()}'),
              ],
            ),
            trailing: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DialogoProductosProforma(
                    productosSeleccionados: proforma.productos,
                  ),
                );
              },
              child: const Icon(
                Icons.receipt_long,
                color: Colors.blue,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductPage(int pageIndex) {
    final startIndex = pageIndex * 5;
    final endIndex = startIndex + 5;
    final pageProductos = proformasFiltrados.sublist(
        startIndex,
        endIndex < proformasFiltrados.length
            ? endIndex
            : proformasFiltrados.length);

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
}

class DialogoProductosProforma extends StatefulWidget {
  final List<Producto> productosSeleccionados;

  const DialogoProductosProforma({
    super.key,
    required this.productosSeleccionados,
  });

  @override
  State<StatefulWidget> createState() => _DialogoProductosProformaState();
}

class _DialogoProductosProformaState extends State<DialogoProductosProforma> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Ajusta el tamaño del diálogo según el contenido
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('Productos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: widget.productosSeleccionados.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final producto = widget.productosSeleccionados[index];
                  return Container(
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
                          Text('Cantidad: ${producto.cantidad}'),
                          Text(
                            'Precio: \$${producto.precioVenta.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
