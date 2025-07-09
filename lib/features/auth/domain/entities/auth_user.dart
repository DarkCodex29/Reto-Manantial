import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoURL,
        isEmailVerified,
      ];
}