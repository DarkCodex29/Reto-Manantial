import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';
import '../../../users/domain/repositories/user_repository.dart';

@injectable
class SignOut {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignOut(this._authRepository, this._userRepository);

  Future<void> call() async {
    await _userRepository.clearLocalUsers();
    await _authRepository.signOut();
  }
}