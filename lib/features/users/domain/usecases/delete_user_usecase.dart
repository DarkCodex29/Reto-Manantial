import 'package:injectable/injectable.dart';
import '../repositories/user_repository.dart';

@injectable
class DeleteUserUseCase {
  final UserRepository repository;

  DeleteUserUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteUser(id);
  }
}