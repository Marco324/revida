import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revida/features/pages/presentation/cubits/analisis/analisis_state.dart';

class AnalisisCubit extends Cubit<AnalisisState> {
  AnalisisCubit() : super(AnalisisInitial());

  Future<String> _copiarModelo() async {
    final byteData = await rootBundle.load('assets/image_model/model.tflite');
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/model.tflite');

    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  Future<void> analizarResiduo(String rutaImagen) async {
    emit(AnalisisLoading());

    ImageLabeler? imageLabeler;
    try {
      final modelPath = await _copiarModelo();
      final options = LocalLabelerOptions(modelPath: modelPath);
      imageLabeler = ImageLabeler(options: options);

      final inputImage = InputImage.fromFilePath(rutaImagen);

      final List<ImageLabel> labels = await imageLabeler.processImage(
        inputImage,
      );

      if (labels.isNotEmpty) {
        labels.sort((a, b) => b.confidence.compareTo(a.confidence));

        final mejorPrediccion = labels.first;

        final indice = mejorPrediccion.index;
        final confianza = mejorPrediccion.confidence;

        final listaEtiquetas = [
          'cardboard',
          'glass',
          'metal',
          'paper',
          'plastic',
        ];

        String objetoDetectado = "desconocido";
        if (indice >= 0 && indice < listaEtiquetas.length) {
          objetoDetectado = listaEtiquetas[indice];
        }

        final categoria = _clasificarEnContenedor(objetoDetectado);

        emit(
          AnalisisSuccess(
            objetoDetectado: objetoDetectado,
            confianza: confianza,
            categoriaResiduo: categoria,
          ),
        );
      } else {
        emit(AnalisisError('No se pudo identificar ningún objeto claramente.'));
      }
    } catch (e, s) {
      print(s);
      emit(AnalisisError('Error al analizar la imagen: $e'));
    } finally {
      imageLabeler?.close();
    }
  }

  String _clasificarEnContenedor(String etiquetaIA) {
    final objeto = etiquetaIA.trim().toLowerCase();

    if (objeto.contains('cardboard') || objeto.contains('paper')) {
      return 'Papel y Cartón 📦';
    } else if (objeto.contains('plastic')) {
      return 'Plástico Reciclable 🥤';
    } else if (objeto.contains('glass')) {
      return 'Vidrio 🍾';
    } else if (objeto.contains('metal')) {
      return 'Metales / Latas 🥫';
    } else {
      return 'Desconocido - Verifica manualmente ⚠️';
    }
  }
}
