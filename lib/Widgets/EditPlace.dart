import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:places_app/Providers/Place.dart';
import 'package:places_app/Providers/Places.dart';
import 'package:places_app/Widgets/MapInput.dart';
import 'package:places_app/Widgets/PhotoInput.dart';
import 'package:provider/provider.dart';

class EditPlace extends StatefulWidget {
  const EditPlace({Key? key}) : super(key: key);

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<EditPlace> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  FocusNode _details = FocusNode();
  String placeId = "";

  Place _place = Place(
    Random().nextInt(1000).toString(),
    "",
    "",
    "",
    PlaceLocation(
      latitude: 0,
      longitude: 0,
    ),
  );

  ///filling fields on editing mode
  Map<String, String> _initialValues = {
    "title": "",
    "details": "",
    "address": "",
  };

  ///load route args once
  bool routeLoaded = false;
  @override
  //load data if in editing mode
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
    super.dispose();
  }

  ///saving form
  Future saveForm() async {
    //validation...
    if (!_form.currentState!.validate() ||
            //photo
            _place.imageUrl.isEmpty //||
        //location
        // location == null
        ) return;

    _form.currentState!.save();
    //new place
    if (placeId.isEmpty) {
      await Provider.of<Places>(context, listen: false).addPlace(Place(
        _place.id,
        _place.title,
        _place.details,
        _place.imageUrl,
        _place.location,
      ));
    }
    //editing place
    else {
      await Provider.of<Places>(context, listen: false).updatePlace(Place(
        _place.id,
        _place.title,
        _place.details,
        _place.imageUrl,
        _place.location,
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //if keyboard toggled and it covered text inputs, make widget bigger
      height: max(
        //default size of widget
        MediaQuery.of(context).size.height * 0.7,
        // text widgets size + keyboard size
        MediaQuery.of(context).size.height * 0.2 +
            MediaQuery.of(context).viewInsets.bottom,
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //input texts
                        SizedBox(
                          height: constraints.maxHeight * 0.25,
                          width: constraints.maxWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //title
                              SizedBox(
                                height: constraints.maxHeight * 0.25 * 0.45,
                                child: TextFormField(
                                  //
                                  decoration: InputDecoration(
                                    labelText: "Title",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  //
                                  initialValue: _initialValues["title"],
                                  //
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_details);
                                  },
                                  //
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description.';
                                    }
                                    return null;
                                  },
                                  //
                                  onSaved: (value) {
                                    _place = Place(
                                      _place.id,
                                      //
                                      value!,
                                      _place.details,
                                      _place.imageUrl,
                                      _place.location,
                                    );
                                  },
                                ),
                              ),

                              //details
                              SizedBox(
                                height: constraints.maxHeight * 0.25 * 0.45,
                                child: TextFormField(
                                  //
                                  decoration: InputDecoration(
                                    labelText: "Details",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  //
                                  initialValue: _initialValues["details"],
                                  //
                                  focusNode: _details,
                                  //
                                  onFieldSubmitted: (value) {
                                    saveForm();
                                  },
                                  //
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description.';
                                    }
                                    return null;
                                  },
                                  //
                                  onSaved: (value) {
                                    _place = Place(
                                      _place.id,
                                      _place.title,
                                      //
                                      value!,
                                      _place.imageUrl,
                                      _place.location,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //map and photo
                        SizedBox(
                          height: constraints.maxHeight * 0.6,
                          width: constraints.maxWidth,
                          //specefic view for mobile and desktop
                          child: Platform.isAndroid || Platform.isIOS
                              ? Column(
                                  // PhotoInput
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: PhotInput(addImage: (XFile file) {
                                        _place = Place(
                                          _place.id,
                                          _place.title,
                                          _place.details,
                                          //image path
                                          file.path,
                                          _place.location,
                                        );
                                      }),
                                    ),
                                    // MapInput
                                    Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                        child: MapInput(
                                            addLocation: (PlaceLocation location) {
                                          _place = Place(
                                            _place.id,
                                            _place.title,
                                            _place.details,
                                            _place.imageUrl,
                                            //location
                                            location,
                                          );
                                        }),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    // PhotoInput
                                    Flexible(
                                      flex: 1,
                                      child: PhotInput(addImage: (XFile file) {
                                        _place = Place(
                                          _place.id,
                                          _place.title,
                                          _place.details,
                                          //image path
                                          file.path,
                                          _place.location,
                                        );
                                      }),
                                    ),
                                    // MapInput
                                    Flexible(
                                      flex: 1,
                                      child: MapInput(
                                          addLocation: (PlaceLocation location) {
                                        _place = Place(
                                          _place.id,
                                          _place.title,
                                          _place.details,
                                          _place.imageUrl,
                                          //location
                                          location,
                                        );
                                      }),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await saveForm();
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
