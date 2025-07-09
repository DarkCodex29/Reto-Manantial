import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getUsers();
  Future<void> cacheUsers(List<UserModel> users);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(int id);
  Future<List<UserModel>> getLocalUsers();
  Future<void> clearLocalUsers();
}