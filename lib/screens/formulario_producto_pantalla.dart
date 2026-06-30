import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';
import '../providers/producto_proveedor.dart';

class FormularioProductoPantalla extends StatefulWidget {
  final Producto? producto;

  const FormularioProductoPantalla({
    super.key,
    this.producto,
  });

  @override
  State<FormularioProductoPantalla> createState() =>
      _FormularioProductoPantallaState();
}

class _FormularioProductoPantallaState
    extends State<FormularioProductoPantalla> {
  final claveFormulario = GlobalKey<FormState>();

  final tituloControlador = TextEditingController();
  final precioControlador = TextEditingController();
  final descripcionControlador = TextEditingController();
  final imagenControlador = TextEditingController();
  final categoriaControlador = TextEditingController();

  bool estaGuardando = false;

  bool get esEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();

    if (esEdicion) {
      tituloControlador.text = widget.producto!.titulo;
      precioControlador.text = widget.producto!.precio.toString();
      descripcionControlador.text = widget.producto!.descripcion;
      imagenControlador.text = widget.producto!.imagen;
      categoriaControlador.text = widget.producto!.idCategoria.toString();
    } else {
      categoriaControlador.text = '1';
      imagenControlador.text = 'https://placehold.co/600x400';
    }
  }

  @override
  void dispose() {
    tituloControlador.dispose();
    precioControlador.dispose();
    descripcionControlador.dispose();
    imagenControlador.dispose();
    categoriaControlador.dispose();
    super.dispose();
  }

  String? validarTexto(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obligatorio';
    }

    return null;
  }

  String? validarNumero(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obligatorio';
    }

    if (int.tryParse(valor) == null) {
      return 'Debe ingresar un número';
    }

    return null;
  }

  String? validarImagen(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obligatorio';
    }

    if (!valor.startsWith('http')) {
      return 'Debe ingresar una URL válida';
    }

    return null;
  }

  Future<void> guardarProducto() async {
    if (!claveFormulario.currentState!.validate()) {
      return;
    }

    setState(() {
      estaGuardando = true;
    });

    final proveedor = Provider.of<ProductoProveedor>(
      context,
      listen: false,
    );

    bool resultado;

    if (esEdicion) {
      resultado = await proveedor.editarProducto(
        id: widget.producto!.id,
        titulo: tituloControlador.text.trim(),
        precio: int.parse(precioControlador.text.trim()),
        descripcion: descripcionControlador.text.trim(),
        idCategoria: int.parse(categoriaControlador.text.trim()),
        imagen: imagenControlador.text.trim(),
      );
    } else {
      resultado = await proveedor.registrarProducto(
        titulo: tituloControlador.text.trim(),
        precio: int.parse(precioControlador.text.trim()),
        descripcion: descripcionControlador.text.trim(),
        idCategoria: int.parse(categoriaControlador.text.trim()),
        imagen: imagenControlador.text.trim(),
      );
    }

    if (!mounted) return;

    setState(() {
      estaGuardando = false;
    });

    if (resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            esEdicion
                ? 'Producto actualizado correctamente'
                : 'Producto registrado correctamente',
          ),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error al guardar'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tituloPantalla = esEdicion ? 'Editar producto' : 'Registrar producto';

    return Scaffold(
      appBar: AppBar(
        title: Text(tituloPantalla),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: claveFormulario,
          child: Column(
            children: [
              TextFormField(
                controller: tituloControlador,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                ),
                validator: validarTexto,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: precioControlador,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: validarNumero,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: categoriaControlador,
                decoration: const InputDecoration(
                  labelText: 'ID de categoría',
                  border: OutlineInputBorder(),
                  helperText: 'Ejemplo: 1, 2, 3, 4',
                ),
                keyboardType: TextInputType.number,
                validator: validarNumero,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imagenControlador,
                decoration: const InputDecoration(
                  labelText: 'URL de imagen',
                  border: OutlineInputBorder(),
                  helperText: 'Ejemplo: https://placehold.co/600x400',
                ),
                validator: validarImagen,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descripcionControlador,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: validarTexto,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: estaGuardando ? null : guardarProducto,
                  icon: estaGuardando
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.save),
                  label: Text(
                    estaGuardando
                        ? 'Guardando...'
                        : esEdicion
                        ? 'Actualizar'
                        : 'Registrar',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}