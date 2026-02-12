import 'package:revida/features/auth/domain/datasources/auth_datasource.dart';
import 'package:revida/features/auth/domain/entities/app_user.dart';
import 'package:revida/features/auth/domain/repositories/auth_repository.dart';
import 'package:revida/features/auth/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
    : datasource = datasource ?? AuthDatasourceImpl();


  @override
  Future<void> deleteAccount() {
    return datasource.deleteAccount();
  }

  @override
  Future<AppUser?> getCurrentUser() {
    return datasource.getCurrentUser();
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) {
    return datasource.loginWithEmailPassword(email, password);
  }

  @override
  Future<void> logout() {
    return datasource.logout();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password) {
    return datasource.registerWithEmailPassword(name, email, password);
  }

  @override
  Future<String> sendPasswordResetEmail(String email) {
    return datasource.sendPasswordResetEmail(email);
  }
  
}