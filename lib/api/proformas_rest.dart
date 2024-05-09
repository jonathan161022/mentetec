import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'configuracion.dart';

//Método api para obtener productos
Future<http.Response> crearProforma(
  Map<String, dynamic> proforma,
  String token,
) async {
  if (kDebugMode) {
    print('$proforma + $token');
  }
  try {
    final response = await http.post(
      Uri.parse('$ipServer/proformaGeneral/crear'),
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
      body: jsonEncode(proforma),
    );

    return response;
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<http.Response> obtenerTodasProformas(
  int pageInit,
  int pageEnd,
  String token,
  String filtro,
  String valor,
  int empresaId,
  String unidadNegocio,
) async {
  try {
    var requestBody = {
      'empresaId': empresaId,
      'unidadNegocio': unidadNegocio,
    };
    if (filtro != null && valor != null) {
      requestBody[filtro] = valor;
    }

    final response = await http.post(
      Uri.parse('$ipServer/proformaGeneral/search'),
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

Future<String> generarNumeroProforma(
    String unidadNegocio, int empresaId, String token) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$ipServer/proformaGeneral/generar-numero/$unidadNegocio/empresa/$empresaId'),
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      // Parsear el JSON de la respuesta
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Obtener el valor del campo "numero"
      final String numeroProforma = responseData['numero'];

      // Devolver solo el número de proforma
      return numeroProforma;
    } else {
      // Si la solicitud no fue exitosa, lanzar una excepción con el código de estado
      throw Exception('Error: ${response.statusCode}');
    }
  } catch (error) {
    // Si hay un error, lanzar una excepción con el mensaje de error
    throw Exception('Error al realizar la solicitud: $error');
  }
}
