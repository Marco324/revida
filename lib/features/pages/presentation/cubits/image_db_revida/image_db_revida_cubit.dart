import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revida/features/pages/domain/entities/reciclaje.dart';
import 'package:revida/features/pages/domain/repositories/image_db_revida_repository.dart';

part 'image_db_revida_state.dart';

class ImageDbRevidaCubit extends Cubit<ImageDbRevidaState> {
  final ImageDbRevidaRepository repository;

  ImageDbRevidaCubit(this.repository) : super(ImageDbRevidaInitial());

  int calcularRacha(List<Reciclaje> reciclajes) {
    if (reciclajes.isEmpty) return 0;

    final fechas =
        reciclajes
            .map((r) => DateTime(r.date.year, r.date.month, r.date.day))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    final hoy = DateTime.now();
    final ultima = fechas.first;

    final diferenciaHoy = hoy.difference(ultima).inDays;

    if (diferenciaHoy > 1) return 0;

    int racha = 1;

    for (int i = 0; i < fechas.length - 1; i++) {
      final diferencia = fechas[i].difference(fechas[i + 1]).inDays;

      if (diferencia == 1) {
        racha++;
      } else if (diferencia > 1) {
        break;
      }
    }

    return racha;
  }

  // Registrar detección

  Future<void> registrarDeteccion({
    required String pathImagen,
    required String categoria,
    required double confianza,
  }) async {
    try {
      emit(ImageDbRevidaLoading());

      await repository.registrarDeteccion(pathImagen, categoria, confianza);

      emit(ImageDbRevidaSuccess());
      emit(ImageDbRevidaInitial());
    } catch (e) {
      emit(ImageDbRevidaError(e.toString()));
    }
  }

  // Cargar reciclajes

  Future<void> loadReciclajes() async {
    try {
      emit(ImageDbRevidaLoading());

      final reciclajes = await repository.loadReciclajes();

      final racha = calcularRacha(reciclajes);

      emit(ImageDbRevidaLoaded(reciclajes, racha));
    } catch (e) {
      emit(ImageDbRevidaError(e.toString()));
    }
  }
}
