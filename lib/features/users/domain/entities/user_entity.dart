import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String description;
  final double latitude;
  final double longitude;
  final bool isFavorite;
  final bool enableAlert;
  final String photoUrl;
  final String phone;
  final DateTime date;
  final String locationDescription;
  final bool isLocal;

  const UserEntity({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.isFavorite,
    required this.enableAlert,
    required this.photoUrl,
    required this.phone,
    required this.date,
    required this.locationDescription,
    this.isLocal = false,
  });

  UserEntity copyWith({
    int? id,
    String? description,
    double? latitude,
    double? longitude,
    bool? isFavorite,
    bool? enableAlert,
    String? photoUrl,
    String? phone,
    DateTime? date,
    String? locationDescription,
    bool? isLocal,
  }) {
    return UserEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFavorite: isFavorite ?? this.isFavorite,
      enableAlert: enableAlert ?? this.enableAlert,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      date: date ?? this.date,
      locationDescription: locationDescription ?? this.locationDescription,
      isLocal: isLocal ?? this.isLocal,
    );
  }

  @override
  List<Object?> get props => [
        id,
        description,
        latitude,
        longitude,
        isFavorite,
        enableAlert,
        photoUrl,
        phone,
        date,
        locationDescription,
        isLocal,
      ];
}