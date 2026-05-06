class Reciclaje {
  final String categoria;
  final String imageUrl;
  final double confianza;
  final String? userId;
  final DateTime date;

  Reciclaje({
    required this.categoria,
    required this.imageUrl,
    required this.confianza,
    this.userId,
    required this.date,
  });
}
