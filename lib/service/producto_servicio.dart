import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/producto.dart';

class ProductoServicio {
  final String urlBase = 'https://api.escuelajs.co/api/v1';

  Future<List<Producto>> listarProductos() async {
    final respuesta = await http.get(
      Uri.parse('$urlBase/products?offset=0&limit=20'),
    );

    if (respuesta.statusCode == 200) {
      final String cuerpo = utf8.decode(respuesta.bodyBytes);
      final List datos = jsonDecode(cuerpo);

      return datos.map((productoJson) {
        return Producto.desdeJson(productoJson);
      }).toList();
    } else {
      throw Exception('Error al listar los productos');
    }
  }

  Future<void> registrarProducto({
    required String titulo,
    required int precio,
    required String descripcion,
    required int idCategoria,
    required String imagen,
  }) async {
    final respuesta = await http.post(
      Uri.parse('$urlBase/products/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': titulo,
        'price': precio,
        'description': descripcion,
        'categoryId': idCategoria,
        'images': [imagen],
      }),
    );

    if (respuesta.statusCode != 200 && respuesta.statusCode != 201) {
      throw Exception('Error al registrar el producto');
    }
  }

  Future<void> editarProducto({
    required int id,
    required String titulo,
    required int precio,
    required String descripcion,
    required int idCategoria,
    required String imagen,
  }) async {
    final respuesta = await http.put(
      Uri.parse('$urlBase/products/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': titulo,
        'price': precio,
        'description': descripcion,
        'categoryId': idCategoria,
        'images': [imagen],
      }),
    );

    if (respuesta.statusCode != 200) {
      throw Exception('Error al editar el producto');
    }
  }

  Future<void> eliminarProducto(int id) async {
    final respuesta = await http.delete(
      Uri.parse('$urlBase/products/$id'),
    );

    if (respuesta.statusCode != 200 && respuesta.statusCode != 204) {
      throw Exception('Error al eliminar el producto');
    }
  }
}