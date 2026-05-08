import 'package:revida/features/pages/domain/entities/reciclaje.dart';

abstract class RevidaRepository {
  Future<void> procesarYGuardarDeteccion();
  Future<List<Reciclaje>> loadReciclajes();
  Future<List<Reciclaje>> borrarData();
}