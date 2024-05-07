import 'package:flutter/material.dart';
import 'package:flutter_mentetec/custom/customTextField.dart';
import 'package:flutter_mentetec/model/model_clientes.dart';
import 'package:flutter_mentetec/screens/clientes/clientes_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/clientes_rest.dart';
import '../../custom/styles.dart';

class ClienteCreate extends StatefulWidget {
  final bool isEditing;
  final Persona? cliente;
  const ClienteCreate({super.key, required this.isEditing, this.cliente});

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

// Función para crear un cliente
  Future<void> crearCliente() async {
    if (_nombreCliente.text.isEmpty ||
        _apellidoCliente.text.isEmpty ||
        _dniCliente.text.isEmpty ||
        _direccionCliente.text.isEmpty ||
        _telefonoCliente.text.isEmpty ||
        _correoElectronicoCliente.text.isEmpty ||
        _fechaNacimientoCliente.text.isEmpty ||
        _paisCliente.text.isEmpty ||
        _codigoPaisCliente.text.isEmpty) {
      // Mostrar un mensaje de error indicando que todos los campos son obligatorios
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Todos los campos son obligatorios.'),
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
      return; // Salir del método si hay campos vacíos
    }
    String token =
        (await SharedPreferences.getInstance()).getString('token') ?? '';
    String unidadNegocio =
        (await SharedPreferences.getInstance()).getString('unidadNegocio') ??
            '';

    String nombreCliente = _nombreCliente.text;
    String apillidoCliente = _apellidoCliente.text;
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

    final proformaData = {
      'nombre': nombreCliente,
      'apellido': apillidoCliente,
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
      final response = await crearPersona(proformaData, token);
      // Cliente creado con éxito, cerrar la pantalla de creación de cliente
      Navigator.of(context).pop();
    } catch (e) {
      // Error al crear el cliente, mostrar un mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('No se pudo crear el cliente. Error: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ClientesList()));
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
      // Opcionalmente, puedes registrar el error para fines de depuración
      print('Error al crear el cliente: $e');
    }
  }

  Future<void> editarCliente() async {
    if (_nombreCliente.text.isEmpty ||
        _apellidoCliente.text.isEmpty ||
        _dniCliente.text.isEmpty ||
        _direccionCliente.text.isEmpty ||
        _telefonoCliente.text.isEmpty ||
        _correoElectronicoCliente.text.isEmpty ||
        _fechaNacimientoCliente.text.isEmpty ||
        _paisCliente.text.isEmpty ||
        _codigoPaisCliente.text.isEmpty) {
      // Mostrar un mensaje de error indicando que todos los campos son obligatorios
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Todos los campos son obligatorios.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ClientesList()));
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return; // Salir del método si hay campos vacíos
    }
    String token =
        (await SharedPreferences.getInstance()).getString('token') ?? '';
    String unidadNegocio =
        (await SharedPreferences.getInstance()).getString('unidadNegocio') ??
            '';
    final cliente = widget.cliente!;
    final proformaData = {
      'id': cliente.id,
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
      'unidadNegocio': cliente.unidadNegocio,
      'imagen': '',
    };

    try {
      // Intentar editar el cliente
      final response = await editarPersona(proformaData, token, cliente.id);
      // Cliente editado con éxito, cerrar la pantalla de edición de cliente
      Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.cliente != null) {
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
            CustomTextField(
              controller: _dniCliente,
              labelText: 'DNI del Cliente',
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
                  if (widget.isEditing) {
                    editarCliente();
                  } else {
                    crearCliente();
                  }
                },
                style: CustomStyles.buttonStyle,
                child: Text(
                  widget.isEditing ? 'Editar' : 'Guardar',
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
