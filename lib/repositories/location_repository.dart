import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepository {
  const LocationRepository();

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled. Please enable the services");
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permissions are denied");
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied, we cannot request permissions.");
        return false;
      }

      return true;
    } catch (e) {
      print("Error while handling location permissions: $e");
      return false;
    }
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) return null;
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      print("Error while getting current position: $e");
      return null;
    }
  }

  Future<Location?> getSearchingLocation(String address) async {
    try {
      final location = await locationFromAddress(address);
      return location[0];
    } catch (e) {
      print("Error while searching for location: $e");
      return null;
    }
  }
}