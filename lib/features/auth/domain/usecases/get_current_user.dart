import 'package:injectable/injectable.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetCurrentUser {
  final AuthRepository _authRepository;

  GetCurrentUser(this._authRepository);

  Future<AuthUser?> call() async {
    return await _authRepository.getCurrentUser();
  }
}