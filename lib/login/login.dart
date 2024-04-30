import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../custom/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'styles.dart';
import '../api/login_rest.dart';
import '../Dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      // Llama a la función de inicio de sesión
      final response = await LoginRest.login(username, password);

      // Obtiene los datos de la respuesta
      String token = response.token;
      int idEmpresa = response.idEmpresa;
      String unidadNegocio = response.unidadNegocio;

      // Acceder a la instancia de AuthToken a través de Provider
      AuthToken authToken = Provider.of<AuthToken>(context, listen: false);
      authToken.token = token;

      //Diseño
      String colorBase = response.colorBase;

      // Guarda los datos en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setInt('idEmpresa', idEmpresa);
      prefs.setString('unidadNegocio', unidadNegocio);
      prefs.setString('colorBase', colorBase);

      // Navega a la pantalla de Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error al iniciar sesión: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              "assets/logo.svg",
              width: 50,
              height: 30,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Iniciar sesión',
              style: CustomStyles.titleStyle,
            ),
            const SizedBox(height: 16),
            SvgPicture.asset(
              'assets/solologo.svg',
              width: 70,
              height: 50,
            ),
            const SizedBox(height: 25),
            CustomTextField(
              controller: _usernameController,
              labelText: 'Usuario',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese su usuario';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Contraseña',
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese su contraseña';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: CustomStyles.buttonStyle,
              child: const Text(
                'INGRESAR',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthToken with ChangeNotifier {
  String? _token;

  String? get token => _token;

  set token(String? value) {
    _token = value;
    notifyListeners(); // Notifica a los oyentes sobre el cambio en el token
  }
}
