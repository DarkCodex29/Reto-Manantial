import 'package:injectable/injectable.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignInWithGoogle {
  final AuthRepository _authRepository;

  SignInWithGoogle(this._authRepository);

  Future<AuthUser> call() async {
    return await _authRepository.signInWithGoogle();
  }
}