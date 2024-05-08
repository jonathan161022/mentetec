//Método api para obtener productos
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'configuracion.dart';

Future<http.Response> obtenerTodosClientes(
  int pageInit,
  int pageEnd,
  String token,
  String filtro,
  String valor,
  String unidadNegocio,
) async {
  try {
    var requestBody = {
      'unidadNegocio': unidadNegocio,
    };

    if (filtro != null && valor != null) {
      requestBody[filtro] = valor;
    }

    final response = await http.post(
      Uri.parse('$ipServer/persona/busqueda'),
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
    );

    return response;
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<http.Response> crearPersona(
  Map<String, dynamic> cliente,
  String token,
) async {
  if (kDebugMode) {
    print('Datos cliente: $cliente + $token');
  }

  if (kDebugMode) {
    print('$cliente + $token');
  }
  try {
    final response = await http.post(
      Uri.parse('$ipServer/persona/crear'),
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
      body: jsonEncode(cliente),
    );

    return response;
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<http.Response> editarPersona(
  Map<String, dynamic> cliente,
  String token,
  int id,
) async {
  if (kDebugMode) {
    print('Holi: $cliente + $token + $id');
  }

  if (kDebugMode) {
    print('$cliente + $token');
  }
  try {
    final response = await http.put(
      Uri.parse('$ipServer/persona/$id'), // Cambiar la URL según corresponda
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
      body: jsonEncode(cliente),
    );

    return response;
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<http.Response> buscarPersonaDNI(
    Map<String, dynamic> cliente, String token, String dni) async {
  if (kDebugMode) {
    print('Holi: $token + $dni');
  }

  try {
    final response = await http.get(
      Uri.parse('$ipServer/persona/$dni'),
      // Cambiar la URL según corresponda
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
    );

    return response;
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}
