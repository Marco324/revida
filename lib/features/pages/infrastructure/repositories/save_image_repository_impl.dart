import 'package:revida/features/pages/domain/datasources/save_image_datasource.dart';
import 'package:revida/features/pages/domain/repositories/save_image_repository.dart';
import 'package:revida/features/pages/infrastructure/datasources/save_image_datasource_impl.dart';

class SaveImageRepositoryImpl extends SaveImageRepository {
  final SaveImageDatasource datasource;

  SaveImageRepositoryImpl({SaveImageDatasource? datasource})
    : datasource = datasource ?? SaveImageDatasourceImpl();

  @override
  Future<String?> uploadImage(String imagePath) {
    return datasource.uploadImage(imagePath);
  }
}
