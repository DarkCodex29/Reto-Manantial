import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

@injectable
class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<UserEntity> call(UserEntity user) async {
    return await repository.updateUser(user);
  }
}