import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../env/dev.dart';
import 'configuracion.dart';

Future<http.Response> crearProforma(String cliente, String token) async {
  try {
    var response = await http.post(
      Uri.parse("${ipServer}proformaGeneral/crear"),
      headers: {
        'token': token,
        'Content-Type': 'application/json',
      },
    );

    return response;
  } catch (e) {
    // Captura cualquier error durante la solicitud
    throw Exception('Error al realizar la solicitud: $e');
  }
}