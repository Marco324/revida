import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:revida/features/auth/domain/datasources/auth_datasource.dart';
import 'package:revida/features/auth/domain/entities/app_user.dart';
import 'package:revida/features/auth/presentation/cubits/auth/auth_cubit.dart';

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
  
  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      //begin the interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //user cancelled sign-in
      if(gUser == null) return null;

      //obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      //Create a credential for the user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken:  gAuth.idToken
      );

      //sign in with these credentials
      UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);

      //firebase user
      final firebaseUser = userCredential.user;

      //user cancelled sign-in process
      if(firebaseUser == null) return null;
      
      AppUser appUser = AppUser(uid: firebaseUser.uid, email: firebaseUser.email ?? '');

      return appUser;
    } catch (e) { 
      AuthError(e.toString());
      return null;
    }
  }
  

}
