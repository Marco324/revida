import 'package:revida/features/pages/domain/datasources/revida_datasource.dart';
import 'package:revida/features/pages/domain/entities/reciclaje.dart';
import 'package:revida/features/pages/domain/repositories/revida_repository.dart';
import 'package:revida/features/pages/infrastructure/datasources/revida_datasource_impl.dart';

class RevidaRepositoryImpl extends RevidaRepository {
  final RevidaDatasource datasource;

  RevidaRepositoryImpl({RevidaDatasource? datasource}) : datasource = datasource ?? RevidaDatasourceImpl();


  @override
  Future<List<Reciclaje>> loadReciclajes() {
    // TODO: implement loadReciclajes
    throw UnimplementedError();
  }

  @override
  Future<void> procesarYGuardarDeteccion() {
    // TODO: implement procesarYGuardarDeteccion
    throw UnimplementedError();
  }
  
  @override
  Future<List<Reciclaje>> borrarData() {
    return datasource.borrarData();
  }
  
}