import '../../domain/entities/user_entity.dart';

class UserModel {
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

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      latitude: (json['coordinates']['latitude'] ?? 0.0).toDouble(),
      longitude: (json['coordinates']['longitude'] ?? 0.0).toDouble(),
      isFavorite: json['is_favorite'] ?? false,
      enableAlert: json['enable_alert'] ?? false,
      photoUrl: json['photo_url'] ?? '',
      phone: json['phone'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      locationDescription: json['location_description'] ?? '',
      isLocal: json['isLocal'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'coordinates': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'is_favorite': isFavorite,
      'enable_alert': enableAlert,
      'photo_url': photoUrl,
      'phone': phone,
      'date': date.toIso8601String(),
      'location_description': locationDescription,
      'isLocal': isLocal,
    };
  }

  UserModel copyWith({
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
    return UserModel(
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
}

extension UserModelExtension on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        description: description,
        latitude: latitude,
        longitude: longitude,
        isFavorite: isFavorite,
        enableAlert: enableAlert,
        photoUrl: photoUrl,
        phone: phone,
        date: date,
        locationDescription: locationDescription,
        isLocal: isLocal,
      );
}

extension UserEntityExtension on UserEntity {
  UserModel toModel() => UserModel(
        id: id,
        description: description,
        latitude: latitude,
        longitude: longitude,
        isFavorite: isFavorite,
        enableAlert: enableAlert,
        photoUrl: photoUrl,
        phone: phone,
        date: date,
        locationDescription: locationDescription,
        isLocal: isLocal,
      );
}