import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';

part 'users_event.dart';
part 'users_state.dart';

@injectable
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final NotificationService notificationService;
  final ConnectivityService connectivityService;

  UsersBloc({
    required this.getUsersUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required this.notificationService,
    required this.connectivityService,
  }) : super(UsersInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<CreateUserEvent>(_onCreateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<UserUpdatedEvent>(_onUserUpdated);
    on<UserDeletedEvent>(_onUserDeleted);
  }

  List<UserEntity> _allUsers = [];

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      final isConnected = await connectivityService.isConnected;
      
      if (!isConnected) {
        _allUsers = await getUsersUseCase();
        if (_allUsers.isEmpty) {
          emit(UsersError('Sin conexión a internet y no hay datos almacenados'));
          return;
        }
      } else {
        _allUsers = await getUsersUseCase();
      }

      emit(UsersLoaded(_allUsers, hasReachedMax: true));

      await notificationService.scheduleUserNotifications(_allUsers);
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await createUserUseCase(event.user);
      add(LoadUsersEvent());
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await deleteUserUseCase(event.userId);
      add(UserDeletedEvent(event.userId));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await updateUserUseCase(event.user);
      add(UserUpdatedEvent(event.user));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      final updatedUser = event.user.copyWith(
        isFavorite: !event.user.isFavorite,
      );
      await updateUserUseCase(updatedUser);
      add(UserUpdatedEvent(updatedUser));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onUserUpdated(
    UserUpdatedEvent event,
    Emitter<UsersState> emit,
  ) async {
    final currentState = state;
    if (currentState is UsersLoaded || currentState is UserUpdated) {
      final currentUsers = currentState is UsersLoaded 
          ? currentState.users 
          : (currentState as UserUpdated).users;
      
      final updatedUsers = currentUsers.map((user) {
        return user.id == event.user.id ? event.user : user;
      }).toList();
      
      _allUsers = _allUsers.map((user) {
        return user.id == event.user.id ? event.user : user;
      }).toList();
      
      final hasReachedMax = currentState is UsersLoaded 
          ? currentState.hasReachedMax 
          : (currentState as UserUpdated).hasReachedMax;
      
      emit(UserUpdated(updatedUsers, event.user, hasReachedMax: hasReachedMax));
    }
  }

  Future<void> _onUserDeleted(
    UserDeletedEvent event,
    Emitter<UsersState> emit,
  ) async {
    final currentState = state;
    if (currentState is UsersLoaded) {
      final updatedUsers = currentState.users.where((user) => user.id != event.userId).toList();
      _allUsers = _allUsers.where((user) => user.id != event.userId).toList();
      emit(UsersLoaded(updatedUsers, hasReachedMax: currentState.hasReachedMax));
    }
  }
}
