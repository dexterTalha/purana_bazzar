import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageChooser {

  static Widget makeImageChooser(BuildContext context, int index) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 8,
      title: Text(
        "Choose Source",
        style: TextStyle(
          fontFamily: 'Maven',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Icon(
                        Icons.camera_enhance,
                        size: 30,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Camera")
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Icon(
                        Icons.photo,
                        size: 30,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Gallery")
              ],
            )
          ],
        ),
      ),
    );
  }

}
