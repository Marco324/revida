import 'package:revida/features/pages/domain/entities/reciclaje.dart';

abstract class ImageDbRevidaRepository {
  Future<void> registrarDeteccion(
    String pathImagen,
    String categoria,
    double confianza,
  );
  Future<List<Reciclaje>> loadReciclajes();
}
