import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:places_app/Helpers/LocationHerlper.dart';
import 'package:places_app/Providers/Place.dart';

class MapInput extends StatefulWidget {
  final Function addLocation;
  const MapInput({required this.addLocation, Key? key}) : super(key: key);

  @override
  State<MapInput> createState() => _MapInputState();
}

class _MapInputState extends State<MapInput> {
  String _mapPreview = "";
  String _errorMessage = "No place has chosen!";

  Future<bool> _checkPermissionsAndServices(Location location) async {
    //check permission state
    final permissionStatus = await location.hasPermission();
    final bool hasPermission = (permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.grantedLimited);

    //if does'nt have permission location
    if (!hasPermission) {
      final result = await location.requestPermission();
      final bool gotPermission = (result == PermissionStatus.granted ||
          result == PermissionStatus.grantedLimited);
      return gotPermission;
    }

    //check service state
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      return location.requestService();
    }

    return true;
  }

  Future _getCurrentLocation() async {
    Location location = Location();

    final ok = await _checkPermissionsAndServices(location);
    if (!ok) {
      print("Couldn't acces to location!");
      return;
    }

    final LocationData locationData = await location.getLocation();
    widget.addLocation(PlaceLocation(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    ));
    try {
      final mapTempPreview = LocationHelper.generateLocationPreview(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );
      //test connection
      await http.get(Uri.parse(mapTempPreview));
      //get map preview from google maps api
      _mapPreview = mapTempPreview;
    }
    //error handlings
    on HandshakeException catch (e) {
      print("error in getCurrentLocation: $e");
      _errorMessage = "This service is not available in your region!";
    } on SocketException catch (e) {
      print("error in getCurrentLocation: $e");
      _errorMessage = "No internet connection!";
    }
    setState(() {});
  }

  Future _searchLocation() async {}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, mapPart) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //choose on map
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.map,
                    ),
                  ),
                ),
              ),
              //choose current location
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () async => await _getCurrentLocation(),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.location_on,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //map preview
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _mapPreview.isEmpty
                  ? Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.red)),
                      child: Center(child: Text(_errorMessage)),
                    )
                  : Image.network(
                      _mapPreview,
                      errorBuilder: (_, obj, stackTrace) {
                        final err = obj as NetworkImageLoadException;
                        print(err.toString());
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red)),
                          child: Center(
                            child: Text("Error ${err.statusCode.toString()}"),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
