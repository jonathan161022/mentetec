import 'package:flutter/material.dart';
import 'package:flutter_mentetec/login/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Inicio/inicio.dart';
import '../productos/productos.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  late SharedPreferences prefs;
  String? logo;
  final List<Widget> _pages = [
    const Inicio(),
    const Productos(),
  ];
  Future<void> obtenerDatosLogo() async {
    prefs = await SharedPreferences.getInstance();
    logo = prefs.getString('logo') ?? '';
  }

  Future<void> borrarDatos() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    obtenerDatosLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          logo.toString(),
          width: 50,
          height: 40,
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                  child: CircleAvatar(
                maxRadius: 50,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://i.pinimg.com/236x/00/60/f8/0060f80e1526bbaa26f4c1628cc53c17.jpg'),
              )),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Productos'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_sharp),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                setState(() {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        title: const Text('Alerta'),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('¿Estás seguro de cerrar sesión?'),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar')),
                          TextButton(
                              onPressed: () {
                                borrarDatos();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginForm()),
                                );
                              },
                              child: const Text('Aceptar'))
                        ],
                      );
                    },
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      title: const Text('Alerta'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('¿Estás seguro de cerrar sesión?'),
        ],
      ),
      actions: [
        TextButton(onPressed: () {}, child: const Text('Cancelar')),
        TextButton(onPressed: () {}, child: const Text('Aceptar'))
      ],
    );
  }
}
