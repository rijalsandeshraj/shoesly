import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _locationService = LocationService._();

  factory LocationService() {
    return _locationService;
  }

  LocationService._();

  Future<String> getAddress(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    String? address = placemarks.first.name;
    return address ?? 'Default Location';
  }

  Future<LocationPermission> requestService() async {
    // Geolocator Location permission
    LocationPermission permission;
    // Permission handler for accessing device location
    const locationService = Permission.location;
    if (await locationService.isDenied) {
      PermissionStatus status = await locationService.request();
      if (status != PermissionStatus.granted) {
        return LocationPermission.denied;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermission.denied;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return LocationPermission.deniedForever;
    }

    return LocationPermission.always;
  }

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    return position;
  }
}
