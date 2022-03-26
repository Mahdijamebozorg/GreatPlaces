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
  bool isLoading = false;

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

  ///take user current location
  Future _getCurrentLocation() async {
    //enable CircularProgressIndicator
    isLoading = true;
    setState(() {});

    Location location = Location();
    try {
      //check problems
      final ok = await _checkPermissionsAndServices(location);
      if (!ok) {
        print("Couldn't acces to location!");
        return;
      }

      //get current location
      final LocationData locationData = await location.getLocation();

      final mapTempPreview = LocationHelper.generateLocationPreview(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );
      //test connection
      await http.get(Uri.parse(mapTempPreview));

      //convert location to address
      final String address = await LocationHelper.generateAddressWithLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );
      //add to place
      widget.addLocation(
        PlaceLocation(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          address: address,
        ),
      );
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
    } catch (e) {
      print("error in getCurrentLocation  $e");
      _errorMessage = e.toString();
    }
    //disable CircularProgressIndicator
    isLoading = false;
    setState(() {});
  }

  ///search locations on map
  Future _searchLocation() async {
    isLoading = true;
    setState(() {});
    isLoading = false;
    setState(() {});
  }

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
              child: isLoading
                  //if loading static map
                  ? const Center(child: CircularProgressIndicator())
                  //
                  : _mapPreview.isEmpty
                      //error handling during loading map
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red)),
                          child: Center(child: Text(_errorMessage)),
                        )
                      : Image.network(
                          _mapPreview,
                          //error handling during image proccessing
                          errorBuilder: (_, obj, stackTrace) {
                            final err = obj as NetworkImageLoadException;
                            print(err.toString());
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red)),
                              child: Center(
                                child:
                                    Text("Error ${err.statusCode.toString()}"),
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
