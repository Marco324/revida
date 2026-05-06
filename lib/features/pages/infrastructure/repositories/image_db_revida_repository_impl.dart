import 'package:revida/features/pages/domain/datasources/revida_datasource.dart';
import 'package:revida/features/pages/domain/datasources/save_image_datasource.dart';
import 'package:revida/features/pages/domain/entities/reciclaje.dart';
import 'package:revida/features/pages/domain/repositories/image_db_revida_repository.dart';
import 'package:revida/features/pages/infrastructure/datasources/revida_datasource_impl.dart';
import 'package:revida/features/pages/infrastructure/datasources/save_image_datasource_impl.dart';

class ImageDbRevidaRepositoryImpl extends ImageDbRevidaRepository {
  final SaveImageDatasource imageDatasource;
  final RevidaDatasource revidaDatasource;

  ImageDbRevidaRepositoryImpl({
    SaveImageDatasource? imageDatasource,

    RevidaDatasource? revidaDatasource,
  }) : imageDatasource = imageDatasource ?? SaveImageDatasourceImpl(),
       revidaDatasource = revidaDatasource ?? RevidaDatasourceImpl();

  @override
  Future<void> registrarDeteccion(String pathImagen,
    String categoria,
    double confianza,) async {
    // 1. Subir imagen y obtener link
    final String? url = await imageDatasource.uploadImage(pathImagen);
    
    if (url == null) throw Exception("Error al subir imagen a Cloudinary");

    // 2. Guardar en Firebase usando ese link
    await revidaDatasource.procesarYGuardarDeteccion(categoria, url, confianza);
  }

  @override
  Future<List<Reciclaje>> loadReciclajes() async {
    return await revidaDatasource.loadReciclajes();
  }

}
