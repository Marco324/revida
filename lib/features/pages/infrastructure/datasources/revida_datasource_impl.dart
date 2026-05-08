import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revida/features/pages/domain/datasources/revida_datasource.dart';
import 'package:revida/features/pages/domain/entities/reciclaje.dart';

class RevidaDatasourceImpl extends RevidaDatasource {
  @override
  Future<void> procesarYGuardarDeteccion(
    String categoria,
    String imageUrl,
    double confianza,
  ) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        // 3. Guardar todo en Firestore (colección 'residuos')
        await FirebaseFirestore.instance.collection('residuos').add({
          'categoria': categoria,
          'confianza': confianza,
          'imageUrl': imageUrl,
          'userId': uid,
          'date': FieldValue.serverTimestamp(),
        });
        print("¡Éxito! Imagen y datos guardados.");
      } else {
        print("Error: No hay usuario autenticado.");
      }
    } catch (e) {
      print("Error en el proceso: $e");
    }
  }

  @override
  Future<List<Reciclaje>> loadReciclajes() async {
    try {
      // 1. Obtener el ID del usuario actual
      final String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        print("Error: No hay usuario autenticado.");
        return [];
      }

      // 2. Consultar la colección filtrando por el userId

      final querySnapshot = await FirebaseFirestore.instance
          .collection('residuos')
          .where('userId', isEqualTo: uid)
          .orderBy('date', descending: true)
          .get();

      // 3. Mapear los documentos a tu entidad Reciclaje
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        print('Se mapeo correctamente');

        return Reciclaje(
          categoria: data['categoria'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          confianza: (data['confianza'] as num?)?.toDouble() ?? 0.0,
          date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print("Error al cargar reciclajes: $e");
      return [];
    }
  }

  @override
  Future<List<Reciclaje>> borrarData() async {
    try {
      // Obtener UID del usuario actual
      final String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        print("Error: No hay usuario autenticado.");
        return [];
      }

      // Buscar todos los documentos del usuario
      final querySnapshot = await FirebaseFirestore.instance
          .collection('residuos')
          .where('userId', isEqualTo: uid)
          .get();

      // Eliminar cada documento
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print("Todos los documentos del usuario fueron eliminados.");

      return [];
    } catch (e) {
      print("Error al borrar reciclajes: $e");
      return [];
    }
  }
}
