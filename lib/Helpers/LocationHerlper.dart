import 'package:places_app/Providers/Place.dart';

const String GOOGLE_API_KEY = "AIzaSyAdhzq7HKdJF7bwXleBkSQg5VVtk0cdrXs";

class LocationHelper {
  static String generateLocationPreview(
      {required double latitude, required double longitude}) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
  }
}
