import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathDir;

class EditPlace extends StatefulWidget {
  const EditPlace({Key? key}) : super(key: key);

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<EditPlace> {
  GlobalKey _form = GlobalKey<FormState>();
  FocusNode _details = FocusNode();
  FocusNode _address = FocusNode();
  XFile? _chosenFile = XFile("");

  @override
  void dispose() {
    _details.dispose();
    _address.dispose();
    super.dispose();
  }

  final Map<String, String> _initialValues = {
    "title": "",
    "details": "",
  };

  void saveForm() {
    // if (!_form.currentState.validate()) return;
  }

  Future _takeImage() async {
    final _picker = ImagePicker();

    final imageFile =
        await _picker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (imageFile != null) {
      setState(() {
        _chosenFile = imageFile;
      });
    }
    // available save path
    final appDir = await pathDir.getApplicationDocumentsDirectory();

    // temp file name
    final fileName = path.basename(imageFile?.path as String);

    // saving file to path
    await imageFile?.saveTo("${appDir.path}/$fileName");
  }

  Future _chooseImage() async {
    final _picker = ImagePicker();
    final _pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (_pickedImage != null) {
      setState(() {
        _chosenFile = _pickedImage;
      });
    }
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
                                  initialValue: _initialValues["details"],
                                  focusNode: _address,
                                  onFieldSubmitted: (_) {
                                    _address.unfocus();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // PhotoInput
                        
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
                  onPressed: () {},
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
