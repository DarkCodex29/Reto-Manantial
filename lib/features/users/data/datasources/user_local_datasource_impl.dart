import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_local_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: UserLocalDataSource)
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cachedUsersKey = 'cached_users';
  static const String _localUsersKey = 'local_users';

  UserLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<UserModel>> getUsers() async {
    final cachedUsersJson = sharedPreferences.getString(_cachedUsersKey);
    if (cachedUsersJson != null) {
      final List<dynamic> usersData = jsonDecode(cachedUsersJson);
      return usersData.map((json) => UserModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    final usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
    await sharedPreferences.setString(_cachedUsersKey, usersJson);
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    final localUsers = await getLocalUsers();
    final newUser = user.copyWith(
      isLocal: true,
    );
    localUsers.add(newUser);
    await _saveLocalUsers(localUsers);
    return newUser;
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    if (user.isLocal) {
      final localUsers = await getLocalUsers();
      final index = localUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        localUsers[index] = user;
        await _saveLocalUsers(localUsers);
      }
    } else {
      final cachedUsers = await getUsers();
      final index = cachedUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        cachedUsers[index] = user;
        await cacheUsers(cachedUsers);
      }
    }
    return user;
  }

  @override
  Future<void> deleteUser(int id) async {
    final localUsers = await getLocalUsers();
    localUsers.removeWhere((user) => user.id == id);
    await _saveLocalUsers(localUsers);
    
    final cachedUsers = await getUsers();
    cachedUsers.removeWhere((user) => user.id == id);
    await cacheUsers(cachedUsers);
  }

  @override
  Future<List<UserModel>> getLocalUsers() async {
    final localUsersJson = sharedPreferences.getString(_localUsersKey);
    if (localUsersJson != null) {
      final List<dynamic> usersData = jsonDecode(localUsersJson);
      return usersData.map((json) => UserModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> clearLocalUsers() async {
    await sharedPreferences.remove(_localUsersKey);
  }

  Future<void> _saveLocalUsers(List<UserModel> users) async {
    final usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
    await sharedPreferences.setString(_localUsersKey, usersJson);
  }
}