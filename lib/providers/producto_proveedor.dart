import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../service/producto_servicio.dart';

class ProductoProveedor extends ChangeNotifier {
  final ProductoServicio _productoServicio = ProductoServicio();

  List<Producto> productos = [];
  bool estaCargando = false;
  String mensajeError = '';

  Future<void> obtenerProductos() async {
    estaCargando = true;
    mensajeError = '';
    notifyListeners();

    try {
      productos = await _productoServicio.listarProductos();
    } catch (e) {
      mensajeError = 'No se pudo conectar con la API';
    }

    estaCargando = false;
    notifyListeners();
  }

  Future<bool> registrarProducto({
    required String titulo,
    required int precio,
    required String descripcion,
    required int idCategoria,
    required String imagen,
  }) async {
    try {
      await _productoServicio.registrarProducto(
        titulo: titulo,
        precio: precio,
        descripcion: descripcion,
        idCategoria: idCategoria,
        imagen: imagen,
      );

      await obtenerProductos();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarProducto({
    required int id,
    required String titulo,
    required int precio,
    required String descripcion,
    required int idCategoria,
    required String imagen,
  }) async {
    try {
      await _productoServicio.editarProducto(
        id: id,
        titulo: titulo,
        precio: precio,
        descripcion: descripcion,
        idCategoria: idCategoria,
        imagen: imagen,
      );

      await obtenerProductos();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarProducto(int id) async {
    try {
      await _productoServicio.eliminarProducto(id);
      await obtenerProductos();
      return true;
    } catch (e) {
      return false;
    }
  }
}