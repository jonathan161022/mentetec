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
