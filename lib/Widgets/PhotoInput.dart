import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathDir;

class PhotInput extends StatefulWidget {
  Function addImage;
  PhotInput({
    required this.addImage,
    Key? key,
  }) : super(key: key);

  @override
  State<PhotInput> createState() => _PhotInputState();
}

class _PhotInputState extends State<PhotInput> {
  XFile file = XFile("");

  ///take image if device have camera
  Future _takeImage() async {
    final _picker = ImagePicker();
    final imageFile =
        await _picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile != null) {
      setState(() {
        file = imageFile;
      });
    }
    // available save path
    final appDir = await pathDir.getApplicationDocumentsDirectory();
    // temp file name
    final fileName = path.basename(imageFile?.path as String);
    // saving file to path
    await imageFile?.saveTo("${appDir.path}/$fileName");
  }

  ///choose an image from device
  Future _chooseImage() async {
    final _picker = ImagePicker();
    final _pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    //if an image has choosen
    if (_pickedImage != null) {
      setState(() {
        file = _pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, imagePart) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // chooese button
              ElevatedButton(
                onPressed: _chooseImage,
                child: const Icon(Icons.photo_album),
              ),
              //capture button
              ElevatedButton(
                onPressed: _takeImage,
                child: const Icon(
                  Icons.camera_alt,
                ),
              ),
            ],
          ),
          Expanded(
            //photo preview
            child: file.path == ""
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.red)),
                      child: const Center(child: Text("No image has chosen!")),
                    ),
                  )
                : kIsWeb
                    ? Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.network(
                          file.path,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.file(
                          File(file.path),
                          fit: BoxFit.fill,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
