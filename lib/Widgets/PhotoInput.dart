import 'package:flutter/material.dart';
import 'package:places_app/Providers/Place.dart';
import 'package:provider/provider.dart';

class PhotInput extends StatelessWidget {
  const PhotInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Place>(builder: (context, place, child) {
      return LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight * 0.25,
          width: constraints.maxWidth,
          child: LayoutBuilder(
            builder: (ctx, imagePart) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //buttons
                SizedBox(
                  height: imagePart.maxHeight,
                  width: imagePart.maxWidth * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // chooese button
                      ElevatedButton(
                        onPressed: place.,
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
                ),
                //photo preview
                SizedBox(
                  height: imagePart.maxHeight,
                  width: imagePart.maxWidth * 0.7,
                  child: _chosenFile?.path == ""
                      ? Image.asset(
                          "assets/images/temp.png",
                          fit: BoxFit.scaleDown,
                        )
                      : kIsWeb
                          ? Image.network(
                              _chosenFile?.path ?? "",
                              fit: BoxFit.fill,
                            )
                          : Image.file(
                              File(_chosenFile?.path ?? ""),
                              fit: BoxFit.fill,
                            ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
