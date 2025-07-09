import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/notification_service.dart';
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

  UsersBloc({
    required this.getUsersUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required this.notificationService,
  }) : super(UsersInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<CreateUserEvent>(_onCreateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  List<UserEntity> _allUsers = [];

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      _allUsers = await getUsersUseCase();

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
    print('DEBUG UsersBloc -> _onCreateUser: id=${event.user.id}');
    try {
      print('DEBUG UsersBloc -> llama createUserUseCase');
      await createUserUseCase(event.user);
      print('DEBUG UsersBloc -> createUserUseCase OK');
      add(LoadUsersEvent());
    } catch (e, st) {
      print('DEBUG UsersBloc -> createUserUseCase ERROR: $e');
      print(st);
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await deleteUserUseCase(event.userId);
      add(LoadUsersEvent());
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
      add(LoadUsersEvent());
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
      add(LoadUsersEvent());
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}
