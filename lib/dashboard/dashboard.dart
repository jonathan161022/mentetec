import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Inicio/inicio.dart';
import '../productos/productos.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
              child: Text('Menú'),
            ),
            ListTile(
              title: const Text('Inicio'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: const Text('Productos'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
