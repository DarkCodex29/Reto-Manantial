import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/page_transitions.dart';
import '../bloc/users_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../widgets/animated_user_card.dart';
import '../widgets/user_skeleton.dart';
import '../widgets/connectivity_banner.dart';
import 'user_map_screen.dart';
import 'add_user_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _updatedUserIds = <int>{};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<UsersBloc>()..add(LoadUsersEvent())),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Usuarios'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                Navigator.push(
                  context,
                  SlidePageRoute(
                    child: const UserMapScreen(),
                    direction: AxisDirection.left,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
            ),
          ],
        ),
        body: ConnectivityBanner(
          onRetry: () {
            context.read<UsersBloc>().add(LoadUsersEvent());
          },
          child: BlocConsumer<UsersBloc, UsersState>(
            listener: (context, state) {
              if (state is UserUpdated) {
                setState(() {
                  _updatedUserIds.add(state.updatedUser.id);
                });
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (mounted) {
                    setState(() {
                      _updatedUserIds.remove(state.updatedUser.id);
                    });
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is UsersLoading) {
                return const UserSkeletonList();
              } else if (state is UsersError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<UsersBloc>().add(LoadUsersEvent());
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              } else if (state is UsersLoaded || state is UserUpdated) {
                final users = state is UsersLoaded
                    ? state.users
                    : (state as UserUpdated).users;

                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay usuarios disponibles',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<UsersBloc>().add(LoadUsersEvent());
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final isUpdated = _updatedUserIds.contains(user.id);

                      return Slidable(
                        key: ValueKey(user.id),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                context.read<UsersBloc>().add(
                                  ToggleFavoriteEvent(user),
                                );
                              },
                              backgroundColor: user.isFavorite
                                  ? Colors.grey
                                  : Colors.amber,
                              foregroundColor: Colors.white,
                              icon: user.isFavorite
                                  ? Icons.star_outline
                                  : Icons.star,
                              label: user.isFavorite ? 'Quitar' : 'Favorito',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                _showEditDialog(context, user);
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Editar',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _showDeleteDialog(context, user);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Eliminar',
                            ),
                          ],
                        ),
                        child: AnimatedUserCard(
                          user: user,
                          isUpdated: isUpdated,
                        ),
                      );
                    },
                  ),
                );
              }
              return const UserSkeletonList();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final usersBloc = context.read<UsersBloc>();
            Navigator.push(
              context,
              ScalePageRoute(
                child: BlocProvider.value(
                  value: usersBloc,
                  child: const AddUserScreen(),
                ),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, user) {
    final TextEditingController descriptionController = TextEditingController(
      text: user.description,
    );
    final TextEditingController locationController = TextEditingController(
      text: user.locationDescription,
    );
    final TextEditingController phoneController = TextEditingController(
      text: user.phone,
    );
    final TextEditingController latitudeController = TextEditingController(
      text: user.latitude.toString(),
    );
    final TextEditingController longitudeController = TextEditingController(
      text: user.longitude.toString(),
    );

    final usersBloc = context.read<UsersBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Descripción de ubicación',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: latitudeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Latitud',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: longitudeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Longitud',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _getCurrentLocationForEdit(
                  latitudeController,
                  longitudeController,
                ),
                icon: const Icon(Icons.my_location, size: 18),
                label: const Text('Obtener ubicación actual'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (descriptionController.text.isNotEmpty) {
                final updatedUser = user.copyWith(
                  description: descriptionController.text,
                  locationDescription: locationController.text,
                  phone: phoneController.text,
                  latitude:
                      double.tryParse(latitudeController.text) ?? user.latitude,
                  longitude:
                      double.tryParse(longitudeController.text) ??
                      user.longitude,
                );
                usersBloc.add(UpdateUserEvent(updatedUser));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, user) {
    final usersBloc = context.read<UsersBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${user.description}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              usersBloc.add(DeleteUserEvent(user.id));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocationForEdit(
    TextEditingController latController,
    TextEditingController lngController,
  ) async {
    try {
      final locationService = getIt<LocationService>();
      final position = await locationService.getCurrentPosition();

      latController.text = position.latitude.toString();
      lngController.text = position.longitude.toString();
    } catch (e) {}
  }
}
