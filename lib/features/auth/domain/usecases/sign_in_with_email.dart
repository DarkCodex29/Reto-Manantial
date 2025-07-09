import 'package:injectable/injectable.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignInWithEmail {
  final AuthRepository _authRepository;

  SignInWithEmail(this._authRepository);

  Future<AuthUser> call(String email, String password) async {
    return await _authRepository.signInWithEmailAndPassword(email, password);
  }
}