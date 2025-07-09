part of 'users_bloc.dart';

abstract class UsersEvent {}

class LoadUsersEvent extends UsersEvent {}

class CreateUserEvent extends UsersEvent {
  final UserEntity user;
  CreateUserEvent(this.user);
}

class DeleteUserEvent extends UsersEvent {
  final int userId;
  DeleteUserEvent(this.userId);
}

class UpdateUserEvent extends UsersEvent {
  final UserEntity user;
  UpdateUserEvent(this.user);
}

class ToggleFavoriteEvent extends UsersEvent {
  final UserEntity user;
  ToggleFavoriteEvent(this.user);
}

class UserUpdatedEvent extends UsersEvent {
  final UserEntity user;
  UserUpdatedEvent(this.user);
}

class UserDeletedEvent extends UsersEvent {
  final int userId;
  UserDeletedEvent(this.userId);
}
