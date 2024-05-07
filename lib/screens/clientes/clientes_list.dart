import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentetec/model/model_clientes.dart';
import 'package:flutter_mentetec/screens/clientes/clientes_create.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/clientes_rest.dart';

class ClientesList extends StatefulWidget {
  const ClientesList({super.key});

  @override
  State<ClientesList> createState() => _ClientesListState();
}

class _ClientesListState extends State<ClientesList>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  List<Persona> listaClientes = [];
  List<Persona> clientesSeleccionados = [];
  String filtro = 'nombre'; // Inicialmente busca por nombre
  int pageInit = 0;
  int pageEnd = 5;
  late SharedPreferences prefs;
  int empresaId = 0;
  String unidadNegocio = '';
  String token = '';
  String valor = '';
  List<Persona> clientesFiltrados = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: 2, vsync: this);
    obtenerDatosUsuario();

    // Agrega un listener al pageController
  }

  Future<void> obtenerDatosUsuario() async {
    prefs = await SharedPreferences.getInstance();
    empresaId = prefs.getInt('idEmpresa') ?? 0;
    unidadNegocio = prefs.getString('unidadNegocio') ?? '';
    token = prefs.getString('token') ?? '';
    cargarClientes();

  }

  Future<void> cargarClientes({String? searchText}) async {
    String valor = searchText ?? _searchController.text;

    try {
      final response = await obtenerTodosClientes(
          0, 5, token, filtro, valor, empresaId, unidadNegocio);
      final List<dynamic> clientesResponse = jsonDecode(response.body)['data'];
      final List<Persona> clientes = [];

      for (dynamic clienteData in clientesResponse) {
        Persona cliente = Persona(
          id:clienteData['id'],
          nombre: clienteData['nombre'] ?? '',
          apellido: clienteData['apellido'] ?? '',
          dni: clienteData['dni'] ?? '',
          tipoDocumento: clienteData['tipoDocumento'] ?? '',
          direccion: clienteData['direccion'] ?? '',
          telefono: clienteData['telefono'] ?? '',
          correoElectronico: clienteData['correoElectronico'] ?? '',
          genero: clienteData['genero'] ?? '',
          estadoCivil: clienteData['estadoCivil'] ?? '',
          fechaNacimiento: clienteData['fechaNacimiento'] ?? '',
          unidadNegocio: clienteData['unidadNegocio'] ?? '',
          pais: clienteData['pais'] ?? '',
          codigoPais: clienteData['codigoPais'] ?? '',
          imagen: null,
        );

        clientes.add(cliente);
      }

      setState(() {
        listaClientes = clientes;
        clientesFiltrados = clientes; // Inicializa la lista filtrada
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error al cargar clientes: $error');
      }
    }
  }

  void onSearchTextChanged(String searchText) {
    cargarClientes(searchText: searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Retrocede a la pantalla anterior
          },
        ),
        automaticallyImplyLeading: true,
        title: const Text('Clientes'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons
                  .person_add_sharp), // Aquí puedes usar el icono que desees
              onPressed: () {
                // Agrega aquí la acción que deseas realizar al hacer clic en el icono
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ClienteCreate(isEditing: false)));
              },
            ),
          ),
        ],
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
              itemCount: (clientesFiltrados.length / 5).ceil(),
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
                      _tabController.index = _pageController.page!.toInt() - 1;
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
                        (listaClientes.length / 5).ceil() - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                      _tabController.index = _pageController.page!.toInt() + 1;
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

  Widget _buildProductPage(int pageIndex) {
    final startIndex = pageIndex * 5;
    final endIndex = startIndex + 5;
    final pageProductos = clientesFiltrados.sublist(
        startIndex,
        endIndex < clientesFiltrados.length
            ? endIndex
            : clientesFiltrados.length);

    return ListView.separated(
      itemCount: pageProductos.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 10,
      ), // Separador entre elementos
      itemBuilder: (context, index) {
        final producto = pageProductos[index];
        return _buildProductItem(producto);
      },
    );
  }

  Widget _buildProductItem(Persona cliente) {
    return ClipRRect(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(241, 241, 241, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {},
          title: Text(cliente.dni),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${cliente.nombre} ${cliente.apellido}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit), // Icono para editar
            onPressed: () {
              // Acción al hacer clic en el botón de editar
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ClienteCreate(isEditing: true, cliente: cliente,)));
            },
          ),
        ),
      ),
    );
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
          value: 'dni',
          child: Text('DNI'),
        ),
        const PopupMenuItem<String>(
          value: 'nombre',
          child: Text('Nombre'),
        ),
        const PopupMenuItem<String>(
          value: 'apellido',
          child: Text('Apellido'),
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

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    setState(() {
      _tabController.index = currentPageIndex;
    });
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
}
