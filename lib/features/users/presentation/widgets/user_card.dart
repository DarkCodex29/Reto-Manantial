import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/phone_service.dart';
import '../../domain/entities/user_entity.dart';
import 'package:intl/intl.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: user.photoUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    user.photoUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        user.description.isNotEmpty
                            ? user.description[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                )
              : Text(
                  user.description.isNotEmpty
                      ? user.description[0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        title: Text(
          user.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.locationDescription),
            const SizedBox(height: 4),
            if (user.phone.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    user.phone,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd-MM-yyyy').format(user.date),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Lat: ${user.latitude.toStringAsFixed(4)}, Lng: ${user.longitude.toStringAsFixed(4)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.phone.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () => _makePhoneCall(user.phone),
                tooltip: 'Llamar',
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user.isFavorite)
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                if (user.enableAlert)
                  const Icon(
                    Icons.notifications_active,
                    color: Colors.green,
                    size: 20,
                  ),
                if (user.isLocal)
                  const Icon(Icons.offline_pin, color: Colors.grey, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      await getIt<PhoneService>().makePhoneCall(phoneNumber);
    } catch (e) {
      debugPrint('Error al realizar la llamada: $e');
    }
  }
}
