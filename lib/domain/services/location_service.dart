import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Resultado da captura de localização.
class CapturedLocation {
  final double latitude;
  final double longitude;
  final String? address;
  const CapturedLocation(this.latitude, this.longitude, this.address);
}

/// Falha amigável (com mensagem em pt-BR) ao capturar localização.
class LocationFailure implements Exception {
  final String message;
  LocationFailure(this.message);
  @override
  String toString() => message;
}

/// Captura coordenadas (geolocator) e resolve o endereço (geocoding).
class LocationService {
  /// Pede permissão, obtém a posição atual e tenta resolver o endereço.
  Future<CapturedLocation> capture() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw LocationFailure('Ative o GPS/localização do aparelho para continuar.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw LocationFailure('Permissão de localização negada.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw LocationFailure(
          'Permissão de localização bloqueada. Libere nas configurações do Android.');
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    String? address;
    try {
      final places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (places.isNotEmpty) {
        address = _formatAddress(places.first);
      }
    } catch (_) {
      // Endereço reverso é opcional; coordenadas já bastam.
    }

    return CapturedLocation(pos.latitude, pos.longitude, address);
  }

  String _formatAddress(Placemark p) {
    final parts = <String?>[
      p.street,
      p.subLocality,
      p.locality,
      p.administrativeArea,
      p.country,
    ].where((s) => s != null && s.trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  /// URL do Google Maps para um ponto — usada por url_launcher e share_plus.
  static String googleMapsUrl(double lat, double lng) =>
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
}
