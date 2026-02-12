import 'package:firebase_auth/firebase_auth.dart';
import 'package:revida/features/auth/domain/datasources/auth_datasource.dart';
import 'package:revida/features/auth/domain/entities/app_user.dart';

//Firebase authentication - Backend

class AuthDatasourceImpl extends AuthDatasource {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //! Login
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      //attemp sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AppUser appUser = AppUser(uid: userCredential.user!.uid, email: email);

      return appUser;
    } catch (e) {
      throw Exception('Login failed $e');
    }
  }

  //! Register
  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      AppUser appUser = AppUser(uid: userCredential.user!.uid, email: email);

      return appUser;
    } catch (e) {
      throw Exception('Registration failed $e');
    }
  }


  //!Delete Acount
  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;

      if(user == null) throw Exception('No user logged in...');

      await user.delete();

      await logout();
    } catch (e) {
      throw Exception('Failed to delete account $e');
    }
  }


  //! Get current user
  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) return null;

    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!);
  }

  
  //! Logout
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  
  //! Reset password
  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Password reset email! Check your inbox.';
    } catch (e) {
      return 'An error ocurred $e';
    }
  }
}
