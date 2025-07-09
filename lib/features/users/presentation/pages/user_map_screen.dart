import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/users_bloc.dart';
import '../../../../core/services/location_service.dart';

class UserMapScreen extends StatefulWidget {
  const UserMapScreen({super.key});

  @override
  State<UserMapScreen> createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  LatLng? _mapCenter;
  bool _showUsers = true;

  static const LatLng _fallbackLatLng = LatLng(-6.7714, -79.8409);

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final locationService = getIt<LocationService>();
    LatLng target;
    try {
      final position = await locationService.getCurrentPosition();
      target = LatLng(position.latitude, position.longitude);
    } catch (_) {
      target = _fallbackLatLng;
    }
    if (mounted) {
      setState(() {
        _mapCenter = target;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UsersBloc>()..add(LoadUsersEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mapa de Usuarios'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(_showUsers ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _showUsers = !_showUsers;
                });
              },
              tooltip: _showUsers ? 'Ocultar usuarios' : 'Mostrar usuarios',
            ),
          ],
        ),
        body: Stack(
          children: [
            BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoaded) {
                  _markers = state.users.map((user) {
                    return Marker(
                      width: 40,
                      height: 40,
                      point: LatLng(user.latitude, user.longitude),
                      child: Icon(
                        Icons.location_pin,
                        color: user.isFavorite ? Colors.amber : Colors.red,
                        size: 40,
                      ),
                    );
                  }).toList();

                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _mapCenter ?? _fallbackLatLng,
                      initialZoom: 13,
                      maxZoom: 18,
                      minZoom: 3,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.reto_manantial',
                      ),
                      if (_showUsers) MarkerLayer(markers: _markers),
                    ],
                  );
                } else if (state is UsersLoading) {
                  return const Center(child: CircularProgressIndicator());
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
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                onPressed: _centerMapOnUsers,
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.center_focus_strong,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _centerMapOnUsers() {
    if (_markers.isEmpty) return;

    double minLat = _markers.first.point.latitude;
    double maxLat = _markers.first.point.latitude;
    double minLng = _markers.first.point.longitude;
    double maxLng = _markers.first.point.longitude;

    for (final marker in _markers) {
      minLat = marker.point.latitude < minLat ? marker.point.latitude : minLat;
      maxLat = marker.point.latitude > maxLat ? marker.point.latitude : maxLat;
      minLng = marker.point.longitude < minLng
          ? marker.point.longitude
          : minLng;
      maxLng = marker.point.longitude > maxLng
          ? marker.point.longitude
          : maxLng;
    }

    final bounds = LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(100)),
    );
  }
}
