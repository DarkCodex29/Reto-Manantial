import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/connectivity_service.dart';

class ConnectivityBanner extends StatelessWidget {
  final Widget child;
  final VoidCallback? onRetry;

  const ConnectivityBanner({
    super.key,
    required this.child,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: getIt<ConnectivityService>().connectivityStream,
      initialData: true,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;
        
        return Column(
          children: [
            if (!isConnected)
              Container(
                width: double.infinity,
                color: Colors.red,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Sin conexión a internet',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (onRetry != null)
                      TextButton(
                        onPressed: onRetry,
                        child: const Text(
                          'Reintentar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}