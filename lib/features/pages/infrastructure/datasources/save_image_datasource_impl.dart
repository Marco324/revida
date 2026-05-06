import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:revida/features/pages/domain/datasources/save_image_datasource.dart';

class SaveImageDatasourceImpl extends SaveImageDatasource {
  final cloudinary = CloudinaryPublic('dczzjvdwv', 'revida', cache: false);

  @override
  Future<String?> uploadImage(String imagePath) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print("Error de Cloudinary: ${e.message}");
      return null;
    }
  }
}
