class Hospital {
  final String name;
  final double lat;
  final double lng;
  final double distanceKm;
  final String type; // 'hospital', 'clinic', 'pharmacy'
  final String? phone;
  final String? address;

  Hospital({
    required this.name,
    required this.lat,
    required this.lng,
    required this.distanceKm,
    required this.type,
    this.phone,
    this.address,
  });

  factory Hospital.fromOverpass(Map<String, dynamic> element, double userLat, double userLng) {
    final tags = element['tags'] as Map<String, dynamic>? ?? {};
    final lat = (element['lat'] as num).toDouble();
    final lng = (element['lon'] as num).toDouble();

    String type = 'hospital';
    if (tags['amenity'] == 'clinic') type = 'clinic';
    if (tags['amenity'] == 'pharmacy') type = 'pharmacy';

    String name = tags['name'] ??
        tags['name:en'] ??
        tags['operator'] ??
        _defaultName(type);

    return Hospital(
      name: name,
      lat: lat,
      lng: lng,
      distanceKm: _haversine(userLat, userLng, lat, lng),
      type: type,
      phone: tags['phone'] ?? tags['contact:phone'],
      address: tags['addr:full'] ?? tags['addr:street'],
    );
  }

  static String _defaultName(String type) {
    switch (type) {
      case 'clinic': return 'Clinic';
      case 'pharmacy': return 'Pharmacy';
      default: return 'Hospital';
    }
  }

  /// Haversine formula — returns distance in km
  static double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = (dLat / 2) * (dLat / 2) +
        _cosDeg(lat1) * _cosDeg(lat2) * (dLon / 2) * (dLon / 2);
    final c = 2 * _asin(_sqrt(a));
    return r * c;
  }

  static double _toRad(double deg) => deg * 3.14159265358979 / 180;
  static double _cosDeg(double deg) {
    return _cos(_toRad(deg));
  }

  static double _cos(double x) {
    // Taylor series approximation
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / (2 * i * (2 * i - 1));
      result += term;
    }
    return result;
  }

  static double _sqrt(double x) {
    if (x <= 0) return 0;
    double z = x / 2;
    for (int i = 0; i < 50; i++) {
      z = (z + x / z) / 2;
    }
    return z;
  }

  static double _asin(double x) {
    // asin approximation
    x = x.clamp(-1.0, 1.0);
    return x + (x * x * x) / 6 + (3 * x * x * x * x * x) / 40;
  }
}
