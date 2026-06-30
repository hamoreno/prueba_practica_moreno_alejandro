import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';
import '../providers/producto_proveedor.dart';
import 'formulario_producto_pantalla.dart';

class DetalleProductoPantalla extends StatefulWidget {
  final Producto producto;

  const DetalleProductoPantalla({
    super.key,
    required this.producto,
  });

  @override
  State<DetalleProductoPantalla> createState() =>
      _DetalleProductoPantallaState();
}

class _DetalleProductoPantallaState extends State<DetalleProductoPantalla> {
  bool estaEliminando = false;

  Future<void> abrirEditar() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioProductoPantalla(
          producto: widget.producto,
        ),
      ),
    );

    if (resultado == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> confirmarEliminar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar producto'),
          content: const Text(
            '¿Está seguro que desea eliminar este producto?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      eliminarProducto();
    }
  }

  Future<void> eliminarProducto() async {
    setState(() {
      estaEliminando = true;
    });

    final proveedor = Provider.of<ProductoProveedor>(
      context,
      listen: false,
    );

    final resultado = await proveedor.eliminarProducto(widget.producto.id);

    if (!mounted) return;

    setState(() {
      estaEliminando = false;
    });

    if (resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto eliminado correctamente'),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar el producto'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              producto.imagen,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              producto.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Precio: Bs ${producto.precio}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text('Categoría: ${producto.categoria}'),
            const SizedBox(height: 20),
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(producto.descripcion),
            const SizedBox(height: 30),
            estaEliminando
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: abrirEditar,
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: confirmarEliminar,
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}