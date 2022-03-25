import 'package:places_app/Providers/Place.dart';

const String GOOGLE_API_KEY = "AIzaSyAdhzq7HKdJF7bwXleBkSQg5VVtk0cdrXs";
const String NESHAN_API_KEY =
    "service.q4JMk1b75hF9VGn3eRIyEB91REnWjKxhrtQok42V";

class LocationHelper {
  static String generateLocationPreview(
      {required double latitude, required double longitude}) {
    return "https://api.neshan.org/v2/static?key=$NESHAN_API_KEY&type=neshan&zoom=16&center=$latitude,$longitude&width=600&height=300&marker=red";
    // return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
  }
}
