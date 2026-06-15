import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/friend_location_model.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();

  LatLng? _currentPosition;
  List<FriendLocationModel> _friendLocations = [];
  bool _isLoading = true;
  bool _hasPermission = false;
  bool _isSharing = false;
  String? _errorMessage;
  Timer? _refreshTimer;

  static const _defaultCenter = LatLng(27.7172, 85.3240);

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _locationService.stopSharing();
    super.dispose();
  }

  void refresh() => _loadMapData();

  Future<void> _initializeMap() async {
    await _loadMapData();
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _loadMapData(silent: true),
    );
  }

  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _hasPermission = false;
        _errorMessage = 'Location services are disabled on this device.';
      });
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _hasPermission = false;
        _errorMessage = 'Location permission is required to show your position.';
      });
      return false;
    }

    setState(() {
      _hasPermission = true;
      _errorMessage = null;
    });
    return true;
  }

  Future<void> _loadMapData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    final hasPermission = await _ensurePermission();
    if (!hasPermission) {
      if (!silent && mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      await _locationService.updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        isSharing: true,
      );

      final friends = await _locationService.fetchFriendsLocations();

      if (!mounted) return;

      final current = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentPosition = current;
        _friendLocations = friends;
        _isSharing = true;
        _isLoading = false;
        _errorMessage = null;
      });

      _mapController.move(current, _mapController.camera.zoom);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load map data. Pull to refresh or try again.';
      });
    }
  }

  List<Marker> _buildMarkers(ThemeData theme) {
    final markers = <Marker>[];

    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: _currentPosition!,
          width: 48,
          height: 48,
          child: _MapMarker(
            label: 'You',
            color: theme.colorScheme.primary,
            icon: Icons.my_location,
          ),
        ),
      );
    }

    for (final friend in _friendLocations) {
      markers.add(
        Marker(
          point: LatLng(friend.latitude, friend.longitude),
          width: 48,
          height: 48,
          child: _MapMarker(
            label: friend.username,
            color: Colors.green.shade700,
            icon: Icons.person_pin_circle,
          ),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mapCenter = _currentPosition ?? _defaultCenter;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loadMapData,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Center on me',
            onPressed: _currentPosition == null
                ? null
                : () => _mapController.move(_currentPosition!, 15),
            icon: const Icon(Icons.gps_fixed),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(minHeight: 2),

          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: mapCenter,
              initialZoom: 14,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.frontend',
              ),
              MarkerLayer(markers: _buildMarkers(theme)),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),

          if (_errorMessage != null)
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              ),
            ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: theme.colorScheme.primary, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          _isSharing
                              ? 'Sharing your location with friends'
                              : 'Location sharing off',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _LegendRow(
                      color: theme.colorScheme.primary,
                      label: 'You',
                    ),
                    const SizedBox(height: 4),
                    _LegendRow(
                      color: Colors.green.shade700,
                      label: 'Friends sharing location (${_friendLocations.length})',
                    ),
                    if (!_hasPermission) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loadMapData,
                          child: const Text('Enable location'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _MapMarker extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _MapMarker({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        Icon(icon, color: color, size: 34),
      ],
    );
  }
}
