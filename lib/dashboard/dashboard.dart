import 'package:flutter/material.dart';
import '../Inicio/inicio.dart';
import '../productos/productos.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Inicio(),
    Productos(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menú'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Inicio'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Productos'),
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
