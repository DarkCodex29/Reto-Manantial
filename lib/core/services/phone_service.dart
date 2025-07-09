import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@singleton
class PhoneService {
  Future<void> makePhoneCall(String phoneNumber) async {
    final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleanPhoneNumber.isEmpty) {
      throw Exception('Número de teléfono no válido');
    }
    
    final uri = Uri.parse('tel:$cleanPhoneNumber');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('No se puede realizar la llamada');
    }
  }

  Future<bool> canMakePhoneCall(String phoneNumber) async {
    final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleanPhoneNumber.isEmpty) {
      return false;
    }
    
    final uri = Uri.parse('tel:$cleanPhoneNumber');
    return await canLaunchUrl(uri);
  }
}