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
    // 1. Emitimos el estado de carga para que la UI muestre un CircularProgressIndicator
    emit(AnalisisLoading());

    ImageLabeler? imageLabeler;
    try {
      // 2. Configuramos el modelo
      final modelPath = await _copiarModelo();
      final options = LocalLabelerOptions(modelPath: modelPath);
      imageLabeler = ImageLabeler(options: options);

      // 3. Preparamos la imagen
      final inputImage = InputImage.fromFilePath(rutaImagen);

      // 4. Ejecutamos la predicción
      final List<ImageLabel> labels = await imageLabeler.processImage(
        inputImage,
      );

      // 5. Evaluamos los resultados
      if (labels.isNotEmpty) {
        // Ordenamos por confianza de mayor a menor por seguridad
        labels.sort((a, b) => b.confidence.compareTo(a.confidence));

        final mejorPrediccion = labels.first;

        // ¡AQUÍ ESTÁ LA MAGIA! En lugar de .label, usamos .index
        final indice = mejorPrediccion.index;
        final confianza = mejorPrediccion.confidence;

        // Recreamos tu lista de Teachable Machine exactamente en orden
        final listaEtiquetas = [
          'cardboard', // Index 0
          'glass', // Index 1
          'metal', // Index 2
          'paper', // Index 3
          'plastic', // Index 4
        ];

        // Obtenemos el nombre real usando el índice
        String objetoDetectado = "desconocido";
        if (indice >= 0 && indice < listaEtiquetas.length) {
          objetoDetectado = listaEtiquetas[indice];
        }

        // print('LABEL RAW (vacío) -> "${mejorPrediccion.label}"');
        // print('ÍNDICE IA -> $indice');
        // print('OBJETO REAL -> $objetoDetectado');
        // print('CONFIANZA -> $confianza');

        // Pasamos por nuestra lógica de negocio para obtener el contenedor
        final categoria = _clasificarEnContenedor(objetoDetectado);

        // Emitir el resultado final
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
      // print('ERROR MLKIT: $e');
      print(s);
      emit(AnalisisError('Error al analizar la imagen: $e'));
    } finally {
      imageLabeler?.close();
    }
  }

  String _clasificarEnContenedor(String etiquetaIA) {
    // 1. Limpiamos y pasamos a minúsculas por seguridad
    final objeto = etiquetaIA.trim().toLowerCase();

    // 2. Evaluamos si el texto de la IA contiene la palabra clave
    if (objeto.contains('cardboard') || objeto.contains('paper')) {
      return 'Papel y Cartón 📦';
      // O puedes usar: return 'Inorgánico Reciclable ♻️';
    } else if (objeto.contains('plastic')) {
      return 'Plástico Reciclable ♻️';
    } else if (objeto.contains('glass')) {
      return 'Vidrio 🍾';
    } else if (objeto.contains('metal')) {
      return 'Metales / Latas 🥫';
    } else {
      // Si por alguna razón llega algo distinto o el modelo falla
      return 'Desconocido - Verifica manualmente ⚠️';
    }
  }
}
