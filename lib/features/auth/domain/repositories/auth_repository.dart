import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> getCurrentUser();
  Future<AuthUser> signInWithEmailAndPassword(String email, String password);
  Future<AuthUser> signUpWithEmailAndPassword(String email, String password);
  Future<AuthUser> signInWithGoogle();
  Future<void> signOut();
  Stream<AuthUser?> get authStateChanges;
}