import 'package:cirio_app/data/repositories/place_repository.dart';
import 'package:cirio_app/data/services/location_service.dart';
import 'package:cirio_app/features/map/map_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_services.dart';

void main() {
  test('informa que precisa de permissão antes de solicitar ao sistema',
      () async {
    final locationService = FakeLocationService(
      permission: AppLocationPermission.denied,
    );
    final provider = _provider(locationService);

    final result = await provider.locateUser();

    expect(result, LocationRequestResult.permissionRequired);
    expect(locationService.permissionRequests, 0);
    expect(provider.currentLocation, isNull);
  });

  test('solicita permissão e salva a localização atual', () async {
    final locationService = FakeLocationService(
      permission: AppLocationPermission.denied,
      permissionAfterRequest: AppLocationPermission.granted,
      location: const UserLocation(
        latitude: -1.4558,
        longitude: -48.5044,
        accuracy: 12,
      ),
    );
    final provider = _provider(locationService);

    final result = await provider.locateUser(requestPermission: true);

    expect(result, LocationRequestResult.success);
    expect(locationService.permissionRequests, 1);
    expect(provider.currentLocation?.latitude, -1.4558);
    expect(provider.isLocating, isFalse);
  });

  test('orienta a ativar o serviço de localização', () async {
    final provider = _provider(FakeLocationService(serviceEnabled: false));

    final result = await provider.locateUser();

    expect(result, LocationRequestResult.serviceDisabled);
    expect(provider.currentLocation, isNull);
  });

  test('identifica permissão permanentemente negada', () async {
    final provider = _provider(FakeLocationService(
      permission: AppLocationPermission.deniedForever,
    ));

    final result = await provider.locateUser(requestPermission: true);

    expect(result, LocationRequestResult.permissionDeniedForever);
  });
}

MapProvider _provider(FakeLocationService locationService) => MapProvider(
      PlaceRepository(service: FakePlaceService()),
      locationService: locationService,
    );

class FakeLocationService implements LocationService {
  final bool serviceEnabled;
  AppLocationPermission permission;
  final AppLocationPermission permissionAfterRequest;
  final UserLocation location;
  int permissionRequests = 0;

  FakeLocationService({
    this.serviceEnabled = true,
    this.permission = AppLocationPermission.granted,
    AppLocationPermission? permissionAfterRequest,
    this.location = const UserLocation(
      latitude: 0,
      longitude: 0,
      accuracy: 10,
    ),
  }) : permissionAfterRequest = permissionAfterRequest ?? permission;

  @override
  Future<AppLocationPermission> checkPermission() async => permission;

  @override
  Future<UserLocation> getCurrentLocation() async => location;

  @override
  Future<bool> isServiceEnabled() async => serviceEnabled;

  @override
  Future<bool> openAppSettings() async => true;

  @override
  Future<bool> openLocationSettings() async => true;

  @override
  Future<AppLocationPermission> requestPermission() async {
    permissionRequests++;
    permission = permissionAfterRequest;
    return permission;
  }
}
