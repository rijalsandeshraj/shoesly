import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _locationService = LocationService._();

  factory LocationService() {
    return _locationService;
  }

  LocationService._();

  // Gets user current address based on retrieved coordinates
  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark selectedPlacemark = placemarks.last;
      String street = selectedPlacemark.street != null &&
              selectedPlacemark.street!.isNotEmpty
          ? '${selectedPlacemark.street}, '
          : '';
      String locality = selectedPlacemark.locality != null &&
              selectedPlacemark.locality!.isNotEmpty
          ? '${selectedPlacemark.locality}, '
          : '';
      String postalCode = selectedPlacemark.postalCode != null &&
              selectedPlacemark.postalCode!.isNotEmpty
          ? ', ${selectedPlacemark.postalCode}'
          : '';
      String streetAndLocality =
          street == locality ? locality : '$street$locality';
      return '$streetAndLocality${selectedPlacemark.country}$postalCode';
    } catch (e) {
      return 'Default Location';
    }
  }

  // Requests location service for getting location permission
  Future<LocationPermission> requestService() async {
    // Geolocator Location permission
    LocationPermission permission;
    // Permission handler for accessing device location
    const locationService = Permission.location;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

  // Gets current position after location permission is allowed
  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    return position;
  }
}
