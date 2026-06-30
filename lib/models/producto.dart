class Producto {
  final int id;
  final String titulo;
  final int precio;
  final String descripcion;
  final String imagen;
  final String categoria;
  final int idCategoria;

  Producto({
    required this.id,
    required this.titulo,
    required this.precio,
    required this.descripcion,
    required this.imagen,
    required this.categoria,
    required this.idCategoria,
  });

  factory Producto.desdeJson(Map<String, dynamic> json) {
    String imagenProducto = 'https://placehold.co/600x400';

    if (json['images'] is List && json['images'].isNotEmpty) {
      imagenProducto = json['images'][0].toString();
    }

    String nombreCategoria = 'Sin categoría';
    int idCategoriaProducto = 1;

    if (json['category'] != null) {
      nombreCategoria = traducirCategoria(
        json['category']['name'].toString(),
      );

      idCategoriaProducto = convertirAEntero(
        json['category']['id'],
      );
    }

    return Producto(
      id: convertirAEntero(json['id']),
      titulo: json['title']?.toString() ?? '',
      precio: convertirAEntero(json['price']),
      descripcion: json['description']?.toString() ?? '',
      imagen: imagenProducto,
      categoria: nombreCategoria,
      idCategoria: idCategoriaProducto,
    );
  }

  static int convertirAEntero(dynamic valor) {
    if (valor is int) {
      return valor;
    }

    if (valor is double) {
      return valor.toInt();
    }

    if (valor is String) {
      return int.tryParse(valor) ?? 0;
    }

    return 0;
  }

  static String traducirCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'clothes':
        return 'Ropa';
      case 'electronics':
        return 'Electrónica';
      case 'furniture':
        return 'Muebles';
      case 'shoes':
        return 'Zapatos';
      case 'miscellaneous':
        return 'Varios';
      default:
        return categoria;
    }
  }
}