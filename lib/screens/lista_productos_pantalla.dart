import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';
import '../providers/producto_proveedor.dart';
import 'detalle_producto_pantalla.dart';
import 'formulario_producto_pantalla.dart';

class ListaProductosPantalla extends StatefulWidget {
  const ListaProductosPantalla({super.key});

  @override
  State<ListaProductosPantalla> createState() => _ListaProductosPantallaState();
}

class _ListaProductosPantallaState extends State<ListaProductosPantalla> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<ProductoProveedor>(
        context,
        listen: false,
      ).obtenerProductos();
    });
  }

  Future<void> abrirFormulario({Producto? producto}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioProductoPantalla(producto: producto),
      ),
    );

    if (resultado == true && mounted) {
      Provider.of<ProductoProveedor>(
        context,
        listen: false,
      ).obtenerProductos();
    }
  }

  Future<void> abrirDetalle(Producto producto) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleProductoPantalla(producto: producto),
      ),
    );

    if (resultado == true && mounted) {
      Provider.of<ProductoProveedor>(
        context,
        listen: false,
      ).obtenerProductos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final proveedor = Provider.of<ProductoProveedor>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda Virtual'),
        actions: [
          IconButton(
            onPressed: () {
              proveedor.obtenerProductos();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: proveedor.estaCargando
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : proveedor.mensajeError.isNotEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(proveedor.mensajeError),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                proveedor.obtenerProductos();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: proveedor.productos.length,
        itemBuilder: (context, index) {
          final producto = proveedor.productos[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(
                producto.imagen,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported);
                },
              ),
              title: Text(producto.titulo),
              subtitle: Text('Categoría: ${producto.categoria}'),
              trailing: Text('Bs ${producto.precio}'),
              onTap: () {
                abrirDetalle(producto);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          abrirFormulario();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}