import 'package:injectable/injectable.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<UserEntity>> getUsers() async {
    if (await networkInfo.isConnected) {
      final remoteUsers = await remoteDataSource.getUsers();
      await localDataSource.cacheUsers(remoteUsers);
      
      final localUsers = await localDataSource.getLocalUsers();
      final allUsers = [...remoteUsers, ...localUsers];
      
      return allUsers.map((user) => user.toEntity()).toList();
    } else {
      final cachedUsers = await localDataSource.getUsers();
      final localUsers = await localDataSource.getLocalUsers();
      final allUsers = [...cachedUsers, ...localUsers];
      
      return allUsers.map((user) => user.toEntity()).toList();
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    final userModel = user.toModel();
    final createdUser = await localDataSource.createUser(userModel);
    return createdUser.toEntity();
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    final userModel = user.toModel();
    final updatedUser = await localDataSource.updateUser(userModel);
    return updatedUser.toEntity();
  }

  @override
  Future<void> deleteUser(int id) async {
    await localDataSource.deleteUser(id);
  }

  @override
  Future<List<UserEntity>> getLocalUsers() async {
    final localUsers = await localDataSource.getLocalUsers();
    return localUsers.map((user) => user.toEntity()).toList();
  }

  @override
  Future<void> clearLocalUsers() async {
    await localDataSource.clearLocalUsers();
  }
}