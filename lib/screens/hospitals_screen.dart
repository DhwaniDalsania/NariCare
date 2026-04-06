import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/hospital_model.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  bool _isLoading = true;
  bool _showMap = false;
  LocationStatus _status = LocationStatus.enabled;
  Position? _position;
  List<Hospital> _hospitals = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await LocationService.getCurrentPosition();
      
      if (result.status != LocationStatus.enabled) {
        if (mounted) {
          setState(() {
            _status = result.status;
            _isLoading = false;
          });
        }
        return;
      }

      final position = result.position;
      if (position == null) {
        if (mounted) setState(() { _status = LocationStatus.error; _isLoading = false; });
        return;
      }

      _position = position;
      final hospitals = await LocationService.fetchNearbyHospitals(
        _position!.latitude, 
        _position!.longitude
      );

      if (mounted) {
        setState(() {
          _hospitals = hospitals;
          _status = LocationStatus.enabled;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[NARICARE DIAGNOSTICS] Location Load Error: $e');
      if (mounted) {
        setState(() {
          _status = LocationStatus.error;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchMaps(double lat, double lng, String label) async {
    final Uri googleMapsUrl = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    final Uri appleMapsUrl = Uri.parse("https://maps.apple.com/?q=$label&ll=$lat,$lng");
    final Uri browserUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else {
        await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[NARICARE DIAGNOSTICS] Map Launch Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      appBar: AppBar(
        title: Text(l.nearbyHospitals, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (!_isLoading && _status == LocationStatus.enabled)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => setState(() => _showMap = !_showMap),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _showMap ? l.listView : l.mapView,
                    style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(l),
    );
  }

  Widget _buildBody(AppLocalizations l) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.primary),
            const SizedBox(height: 16),
            Text(l.loadingLocation, style: const TextStyle(color: AppTheme.primary)),
          ],
        ),
      );
    }

    if (_status != LocationStatus.enabled) {
      return _buildErrorState(l);
    }

    if (_hospitals.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off_outlined, color: AppTheme.primary, size: 80),
                const SizedBox(height: 24),
                Text(l.noHospitalsFound, style: const TextStyle(color: AppTheme.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('Try broadening your search or check your internet connection.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.primary, fontSize: 14)),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _load, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l.retry)
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_showMap) return _buildMap(l);
    return _buildList(l);
  }

  Widget _buildErrorState(AppLocalizations l) {
    IconData icon = Icons.location_off;
    String message = l.locationPermissionDenied;
    VoidCallback? onAction;
    String actionText = l.openSettings;

    switch (_status) {
      case LocationStatus.disabled:
        icon = Icons.gps_off;
        message = l.locationDisabled;
        onAction = () => Geolocator.openLocationSettings();
        break;
      case LocationStatus.deniedForever:
        icon = Icons.no_encryption;
        message = l.locationPermanentDenied;
        onAction = () => Geolocator.openAppSettings();
        break;
      case LocationStatus.denied:
        icon = Icons.location_searching;
        message = l.locationPermissionDenied;
        onAction = _load;
        actionText = l.retry;
        break;
      default:
        icon = Icons.error_outline;
        message = "An unexpected error occurred.";
        onAction = _load;
        actionText = l.retry;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primary, size: 64),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.primary, fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(actionText),
            ),
            if (_status != LocationStatus.denied)
              TextButton(onPressed: _load, child: Text(l.retry)),
          ],
        ),
      ),
    );
  }

  Widget _buildList(AppLocalizations l) {
    return RefreshIndicator(
      onRefresh: _load,
      color: AppTheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        itemCount: _hospitals.length,
        itemBuilder: (ctx, i) => _HospitalCard(
          hospital: _hospitals[i], 
          l: l,
          onTapMaps: () => _launchMaps(_hospitals[i].lat, _hospitals[i].lng, _hospitals[i].name),
        ),
      ),
    );
  }

  Widget _buildMap(AppLocalizations l) {
    if (_position == null) return const SizedBox();
    final center = LatLng(_position!.latitude, _position!.longitude);

    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: 14.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.naricare',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10)],
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
            ..._hospitals.map((h) => Marker(
              point: LatLng(h.lat, h.lng),
              width: 36,
              height: 36,
              child: GestureDetector(
                onTap: () => _showHospitalInfo(h, l),
                child: Container(
                  decoration: BoxDecoration(
                    color: _typeColor(h.type),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(_typeIcon(h.type), color: Colors.white, size: 18),
                ),
              ),
            )),
          ],
        ),
      ],
    );
  }

  void _showHospitalInfo(Hospital h, AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(_typeIcon(h.type), color: _typeColor(h.type)),
              const SizedBox(width: 8),
              Text(_typeLabel(h.type, l), style: TextStyle(color: _typeColor(h.type), fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _launchMaps(h.lat, h.lng, h.name),
                icon: const Icon(Icons.directions, size: 18),
                label: Text(l.openInMaps),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Text(h.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primary)),
            const SizedBox(height: 4),
            Text('${h.distanceKm.toStringAsFixed(1)} ${l.distance}', style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6))),
            if (h.phone != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('📞 ${h.phone}', style: const TextStyle(color: AppTheme.primary))),
            if (h.address != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text('📍 ${h.address}', style: const TextStyle(color: AppTheme.primary))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'clinic': return Colors.green;
      case 'pharmacy': return Colors.orange;
      default: return AppTheme.primary;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'clinic': return Icons.medical_services;
      case 'pharmacy': return Icons.local_pharmacy;
      default: return Icons.local_hospital;
    }
  }

  String _typeLabel(String type, AppLocalizations l) {
    switch (type) {
      case 'clinic': return l.clinic;
      case 'pharmacy': return l.pharmacy;
      default: return l.hospital;
    }
  }
}

class _HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final AppLocalizations l;
  final VoidCallback onTapMaps;

  const _HospitalCard({required this.hospital, required this.l, required this.onTapMaps});

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(hospital.type);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_typeIcon(hospital.type), color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hospital.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.primary)),
                const SizedBox(height: 2),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(_typeLabel(hospital.type), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  if (hospital.address != null)
                    Expanded(
                      child: Text(hospital.address!, style: TextStyle(color: Colors.grey.shade500, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onTapMaps,
                icon: const Icon(Icons.directions_outlined, color: AppTheme.primary),
                tooltip: l.openInMaps,
              ),
              Text('${hospital.distanceKm.toStringAsFixed(1)} ${l.distance}', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'clinic': return Colors.green;
      case 'pharmacy': return Colors.orange;
      default: return AppTheme.primary;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'clinic': return Icons.medical_services;
      case 'pharmacy': return Icons.local_pharmacy;
      default: return Icons.local_hospital;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'clinic': return l.clinic;
      case 'pharmacy': return l.pharmacy;
      default: return l.hospital;
    }
  }
}
