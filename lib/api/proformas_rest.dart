import 'dart:convert';
import 'package:http/http.dart' as http;
import 'configuracion.dart';

//Método api para obtener productos
Future<http.Response> crearProforma(
  Map<String, dynamic> proforma,
  String token,
) async {
  print('$proforma + $token');
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
