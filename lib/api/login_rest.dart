import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../env/dev.dart';

class LoginResponse {
  final String token;
  final int idEmpresa;
  final String unidadNegocio;
  final String colorBase;
  final String logo;

  LoginResponse(
      {required this.logo,
      required this.token,
      required this.idEmpresa,
      required this.unidadNegocio,
      required this.colorBase});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      idEmpresa: json['idEmpresa'],
      unidadNegocio: json['unidadNegocio'],
      colorBase: json['colorBase'],
      logo: json['logo'],
    );
  }
}

class LoginRest {
  static Future<LoginResponse> login(String userName, String password) async {
    const apiUrl = EnvironmentConfig.apiUrl;
    const endpoint = '$apiUrl/persona/login';
    final body = jsonEncode({'userName': userName, 'password': password});

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return LoginResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Error de inicio de sesión: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en la solicitud: $e');
      }
      throw Exception('Error en la solicitud: $e');
    }
  }
}
