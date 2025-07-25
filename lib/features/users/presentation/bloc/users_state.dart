part of 'users_bloc.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final bool hasReachedMax;

  UsersLoaded(this.users, {this.hasReachedMax = false});
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}

class UserUpdated extends UsersState {
  final List<UserEntity> users;
  final UserEntity updatedUser;
  final bool hasReachedMax;

  UserUpdated(this.users, this.updatedUser, {this.hasReachedMax = false});
}
