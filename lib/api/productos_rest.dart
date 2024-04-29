import 'dart:convert';
import 'package:http/http.dart' as http;
import 'configuracion.dart';

//Método api para obtener productos
Future<http.Response> obtenerTodosProductos(
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
      Uri.parse('$ipServer/inventario/busqueda'),
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
