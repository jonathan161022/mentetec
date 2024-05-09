import 'dart:convert';
import '../../custom/styles.dart';
import '../../model/model_clientes.dart';
import 'package:flutter_mentetec/api/clientes_rest.dart';
import 'package:flutter_mentetec/custom/customTextField.dart';
import 'package:flutter_mentetec/screens/clientes/clientes_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClienteCreate extends StatefulWidget {
  final bool isEditing;
  final Persona? cliente;
  // final String? dni;

  const ClienteCreate({
    super.key,
    this.cliente,
    required this.isEditing,
    // this.dni,
  });

  @override
  State<ClienteCreate> createState() => _ClienteCreateState();
}

class _ClienteCreateState extends State<ClienteCreate> {
  final TextEditingController _nombreCliente = TextEditingController();
  final TextEditingController _apellidoCliente = TextEditingController();
  final TextEditingController _dniCliente = TextEditingController();
  final TextEditingController _tipoDocumentoCliente =
      TextEditingController(text: 'CEDULA');
  final TextEditingController _direccionCliente = TextEditingController();
  final TextEditingController _telefonoCliente = TextEditingController();
  final TextEditingController _correoElectronicoCliente =
      TextEditingController();
  final TextEditingController _generoCliente =
      TextEditingController(text: 'MASCULINO');
  final TextEditingController _estadoCivilCliente =
      TextEditingController(text: 'SOLTERO');
  final TextEditingController _fechaNacimientoCliente = TextEditingController();
  final TextEditingController _paisCliente = TextEditingController();
  final TextEditingController _codigoPaisCliente = TextEditingController();
  bool clienteExistente = false;

// Función para crear un cliente
  Future<void> crearCliente() async {
    String token =
        (await SharedPreferences.getInstance()).getString('token') ?? '';
    String unidadNegocio =
        (await SharedPreferences.getInstance()).getString('unidadNegocio') ??
            '';

    String nombreCliente = _nombreCliente.text;
    String apellidoCliente = _apellidoCliente.text;
    String dniCliente = _dniCliente.text;
    String tipoDocumento = _tipoDocumentoCliente.text;
    String direccionCliente = _direccionCliente.text;
    String telefonoCliente = _telefonoCliente.text;
    String correoCliente = _correoElectronicoCliente.text;
    String estadoCivilCliente = _estadoCivilCliente.text;
    String generoCliente = _generoCliente.text;
    String fechaNacimiento = _fechaNacimientoCliente.text;
    String paisCliente = _paisCliente.text;
    String codigoPaisCliente = _codigoPaisCliente.text;

    Map<String, dynamic> persona = {
      'nombre': nombreCliente,
      'apellido': apellidoCliente,
      'dni': dniCliente,
      'tipoDocumento': tipoDocumento,
      'direccion': direccionCliente,
      'telefono': telefonoCliente,
      'correoElectronico': correoCliente,
      'genero': generoCliente,
      'estadoCivil': estadoCivilCliente,
      'fechaNacimiento': fechaNacimiento,
      'pais': paisCliente,
      'codigoPais': codigoPaisCliente,
      'unidadNegocio': unidadNegocio,
      'imagen': '',
    };

    try {
      // Intentar crear el cliente
      final response = await crearPersona(persona, token);
      // Cliente creado con éxito, cerrar la pantalla de creación de cliente
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ClientesList()));
      mostrarDialogGuardarCliente(context);
    } catch (e) {
      // Error al crear el cliente, mostrar un mensaje de error
      // Opcionalmente, puedes registrar el error para fines de depuración
      print('Error al crear el cliente: $e');
    }
  }

// Método para buscar un cliente por su DNI
  Future<void> buscarClienteDNI() async {
    String token =
        (await SharedPreferences.getInstance()).getString('token') ?? '';

    try {
      final response = await buscarPersonaDNI(token, _dniCliente.text);
      Map<String, dynamic> persona = json.decode(response.body);

      setState(() {
        _nombreCliente.text = persona['nombre'];
        _apellidoCliente.text = persona['apellido'];
        _tipoDocumentoCliente.text = persona['tipoDocumento'];
        _direccionCliente.text = persona['direccion'];
        _telefonoCliente.text = persona['telefono'];
        _correoElectronicoCliente.text = persona['correoElectronico'];
        _estadoCivilCliente.text = persona['estadoCivil'];
        _generoCliente.text = persona['genero'];
        _fechaNacimientoCliente.text = persona['fechaNacimiento'];
        _paisCliente.text = persona['pais'];
        _codigoPaisCliente.text = persona['codigoPais'];
        clienteExistente = true;
      });
    } catch (e) {
      // En caso de error, limpiar los campos
      setState(() {
        _nombreCliente.text = '';
        _apellidoCliente.text = '';
        _direccionCliente.text = '';
        _telefonoCliente.text = '';
        _correoElectronicoCliente.text = '';
        _fechaNacimientoCliente.text = '';
        _paisCliente.text = '';
        _codigoPaisCliente.text = '';
        clienteExistente = false;
      });
      print('Error al buscar el cliente: $e');
    }
  }

  Future<void> mostrarDialogGuardarCliente(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Cliente guardado correctamente.'),
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

  Future<void> editarCliente() async {
    String token =
        (await SharedPreferences.getInstance()).getString('token') ?? '';
    String unidadNegocio =
        (await SharedPreferences.getInstance()).getString('unidadNegocio') ??
            '';

    final cliente = widget.cliente!;
    final proformaData = {
      'nombre': _nombreCliente.text,
      'apellido': _apellidoCliente.text,
      'dni': _dniCliente.text,
      'tipoDocumento': _tipoDocumentoCliente.text,
      'direccion': _direccionCliente.text,
      'telefono': _telefonoCliente.text,
      'correoElectronico': _correoElectronicoCliente.text,
      'genero': _generoCliente.text,
      'estadoCivil': _estadoCivilCliente.text,
      'fechaNacimiento': _fechaNacimientoCliente.text,
      'pais': _paisCliente.text,
      'codigoPais': _codigoPaisCliente.text,
      'unidadNegocio': unidadNegocio,
      'imagen': '',
    };

    try {
      // Intentar editar el cliente
      final response = await editarPersona(proformaData, token, cliente.id);
      print('Response: $response');
      // Cliente editado con éxito, cerrar la pantalla de edición de cliente
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ClientesList()));
      mostrarDialogEditarCliente(context);
    } catch (e) {
      // Error al editar el cliente, mostrar un mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('No se pudo editar el cliente. Error: $e'),
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
      // Opcionalmente, puedes registrar el error para fines de depuración
      print('Error al editar el cliente: $e');
    }
  }

  Future<void> mostrarDialogEditarCliente(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Cliente editado correctamente.'),
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
  void initState() {
    super.initState();

    // Verificar si se está editando y si hay un cliente existente
    clienteExistente = widget.isEditing && widget.cliente != null;

    // Si se está editando y hay un cliente existente, inicializar los campos del formulario
    if (clienteExistente) {
      final cliente = widget.cliente!;
      _nombreCliente.text = cliente.nombre;
      _apellidoCliente.text = cliente.apellido;
      _dniCliente.text = cliente.dni;
      _tipoDocumentoCliente.text = cliente.tipoDocumento;
      _direccionCliente.text = cliente.direccion;
      _telefonoCliente.text = cliente.telefono;
      _correoElectronicoCliente.text = cliente.correoElectronico;
      _estadoCivilCliente.text = cliente.estadoCivil;
      _generoCliente.text = cliente.genero;
      _fechaNacimientoCliente.text = cliente.fechaNacimiento;
      _paisCliente.text = cliente.pais;
      _codigoPaisCliente.text = cliente.codigoPais;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _dniCliente,
                      labelText: 'DNI del Cliente',
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        buscarClienteDNI();
                      },
                      icon: const Icon(Icons.search))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: _nombreCliente,
              labelText: 'Nombre del Cliente',
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: _apellidoCliente,
              labelText: 'Apellido del Cliente',
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              value: _tipoDocumentoCliente.text,
              onChanged: (String? newValue) {
                setState(() {
                  _tipoDocumentoCliente.text = newValue!;
                });
              },
              items: <String>['PASAPORTE', 'CEDULA', 'RUC', 'OTRO']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Tipo del Documento',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: _direccionCliente,
              labelText: 'Dirección del Cliente',
              suffixIcon: Icons.map,
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: _telefonoCliente,
              labelText: 'Teléfono del Cliente',
              suffixIcon: Icons.phone_android,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: _correoElectronicoCliente,
              labelText: 'Correo Electrónico',
              suffixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              value: _estadoCivilCliente.text,
              onChanged: (String? newValue) {
                setState(() {
                  _estadoCivilCliente.text = newValue!;
                });
              },
              items: <String>['SOLTERO', 'CASADO', 'DIVORCIADO']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Estado Civil',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.all(0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _generoCliente.text,
                        onChanged: (String? newValue) {
                          setState(() {
                            _generoCliente.text = newValue!;
                          });
                        },
                        items: <String>[
                          'MASCULINO',
                          'FEMENINO',
                          'NO_BINARIO',
                          'OTRO'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Género',
                        ),
                      ),
                    ),
                    const SizedBox(
                        width:
                            8), // Ajusta el espacio entre los dos campos si es necesario
                    Expanded(
                      child: CustomTextField(
                        controller: _fechaNacimientoCliente,
                        labelText: 'Fecha de Nacimiento',
                        suffixIcon: Icons.calendar_month,
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.all(0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _paisCliente,
                        labelText: 'País',
                        suffixIcon: Icons.location_city_rounded,
                      ),
                    ),
                    const SizedBox(
                        width:
                            8), // Ajusta el espacio entre los dos campos si es necesario
                    Expanded(
                      child: CustomTextField(
                        controller: _codigoPaisCliente,
                        labelText: 'Código País',
                        suffixIcon: Icons.email,
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              width: 8,
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  if (clienteExistente && widget.isEditing) {
                    editarCliente(); // Si el cliente existe y se está editando, llamar a editarCliente()
                  } else {
                    crearCliente(); // Si el cliente no existe o no se está editando, llamar a crearCliente()
                  }
                },
                style: CustomStyles.buttonStyle,
                child: Text(
                  (clienteExistente && widget.isEditing) ? 'Editar' : 'Guardar',
                  style: const TextStyle(color: Colors.white),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
