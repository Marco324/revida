import 'package:revida/features/auth/domain/entities/entities.dart';

abstract class AuthDatasource {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<String> sendPasswordResetEmail(String email);
  Future<void> deleteAccount();
}
