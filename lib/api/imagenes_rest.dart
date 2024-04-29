import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'configuracion.dart';

Future<Uint8List> obtenerImagenes(String token, String imageName) async {
  try {
    final response =
        await http.get(Uri.parse('$ipServer/api/images/$imageName'), headers: {
      'token': token,
    });

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error al obtener la imagen: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}