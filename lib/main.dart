import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/producto_proveedor.dart';
import 'screens/lista_productos_pantalla.dart';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductoProveedor(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tienda Virtual',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        home: const ListaProductosPantalla(),
      ),
    );
  }
}