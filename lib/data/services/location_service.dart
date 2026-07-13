import 'package:geolocator/geolocator.dart';

enum AppLocationPermission { granted, denied, deniedForever }

class UserLocation {
  final double latitude;
  final double longitude;
  final double accuracy;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });
}

abstract interface class LocationService {
  Future<bool> isServiceEnabled();
  Future<AppLocationPermission> checkPermission();
  Future<AppLocationPermission> requestPermission();
  Future<UserLocation> getCurrentLocation();
  Future<bool> openAppSettings();
  Future<bool> openLocationSettings();
}

class GeolocatorLocationService implements LocationService {
  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<AppLocationPermission> checkPermission() async =>
      _mapPermission(await Geolocator.checkPermission());

  @override
  Future<AppLocationPermission> requestPermission() async =>
      _mapPermission(await Geolocator.requestPermission());

  @override
  Future<UserLocation> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );
  }

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  AppLocationPermission _mapPermission(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.whileInUse ||
      LocationPermission.always =>
        AppLocationPermission.granted,
      LocationPermission.deniedForever => AppLocationPermission.deniedForever,
      LocationPermission.denied ||
      LocationPermission.unableToDetermine =>
        AppLocationPermission.denied,
    };
  }
}
