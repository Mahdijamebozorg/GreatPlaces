import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathDir;
import 'package:places_app/Providers/Place.dart';
import 'package:places_app/Providers/Places.dart';
import 'package:places_app/Widgets/PhotoInput.dart';
import 'package:provider/provider.dart';

class EditPlace extends StatefulWidget {
  const EditPlace({Key? key}) : super(key: key);

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<EditPlace> {
  final _form = GlobalKey<FormState>();
  FocusNode _details = FocusNode();
  FocusNode _address = FocusNode();
  XFile? _chosenFile = XFile("");
  String placeId = "";

  Place _place =
      Place("", "", "", "", Location(address: "", latitude: 0, longitude: 0));

  ///filling fields on editing mode
  Map<String, String> _initialValues = {
    "title": "",
    "details": "",
    "address": "",
  };

  bool routeLoaded = false;

  ///load route args once
  @override
  void didChangeDependencies() {
    if (!routeLoaded) {
      final routeArgs = ModalRoute.of(context)!.settings.arguments as String?;
      //editing mode
      if (routeArgs != null) {
        _place = Provider.of<Places>(context, listen: false)
            .places
            .firstWhere((place) => place.id == placeId);
        _initialValues = {
          "title": _place.title,
          "details": _place.details,
          "address": _place.location.address
        };
      }
      routeLoaded = true;
    }
    super.didChangeDependencies();
  }

  ///remove data after distructing
  @override
  void dispose() {
    _details.dispose();
    _address.dispose();
    super.dispose();
  }

  ///saving form
  void saveForm() {
    //validation...

    _form.currentState!.save();
    //new place
    if (placeId.isEmpty) {
      Provider.of<Places>(context).addPlace(Place(
        _place.id,
        _place.title,
        _place.details,
        _place.imageUrl,
        _place.location,
      ));
    }
    //editing place
    else {}
    Provider.of<Places>(context, listen: false).updatePlace(Place(
      _place.id,
      _place.title,
      _place.details,
      _place.imageUrl,
      _place.location,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: max(
        MediaQuery.of(context).size.height * 0.9,
        MediaQuery.of(context).size.height * 0.3 +
            MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (ctx, constraints) => Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //details
                Expanded(
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //input texts
                        SizedBox(
                          height: constraints.maxHeight * 0.35,
                          width: constraints.maxWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //title
                              Flexible(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Title",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  initialValue: _initialValues["title"],
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_details);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _place = Place(
                                        _place.id,
                                        value,
                                        _place.details,
                                        _place.imageUrl,
                                        _place.location,
                                      );
                                    }
                                  },
                                ),
                              ),

                              //details
                              Flexible(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Details",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  initialValue: _initialValues["details"],
                                  focusNode: _details,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_address);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _place = Place(
                                        _place.id,
                                        _place.title,
                                        value,
                                        _place.imageUrl,
                                        _place.location,
                                      );
                                    }
                                  },
                                ),
                              ),

                              //address
                              Flexible(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Adress",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  initialValue: _initialValues["address"],
                                  focusNode: _address,
                                  onFieldSubmitted: (_) {
                                    _address.unfocus();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _place = Place(
                                        _place.id,
                                        _place.title,
                                        _place.details,
                                        _place.imageUrl,
                                        Location(
                                          address: value,
                                          latitude: _place.location.latitude,
                                          longitude: _place.location.longitude,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // PhotoInput
                        PhotInput(addImage: (XFile? file) {
                          _chosenFile = file;
                        }),

                        //map
                        SizedBox(
                          height: constraints.maxHeight * 0.25,
                          width: constraints.maxWidth,
                          child: LayoutBuilder(
                            builder: (ctx, mapPart) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: mapPart.maxWidth * 0.2,
                                  height: mapPart.maxHeight / 2.5,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Icon(
                                      Icons.map,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: mapPart.maxHeight,
                                  width: mapPart.maxWidth * 0.7,
                                  child: Image.asset(
                                    "assets/images/temp.png",
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    saveForm();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add place"),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
