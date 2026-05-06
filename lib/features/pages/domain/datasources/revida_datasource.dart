import 'package:revida/features/pages/domain/entities/reciclaje.dart';

abstract class RevidaDatasource {
  Future<void> procesarYGuardarDeteccion(String categoria, String imageUrl, double confianza);
  Future<List<Reciclaje>> loadReciclajes();
}