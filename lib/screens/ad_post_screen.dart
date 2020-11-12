import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purana_bazzar/utils/constants.dart';

class AdPostScreen extends StatefulWidget {


  @override
  _AdPostScreenState createState() => _AdPostScreenState();
}

class _AdPostScreenState extends State<AdPostScreen> {
  final _titleController = TextEditingController();
  final _descpController = TextEditingController();
  final _yearController = TextEditingController();
  int imageLength = 0, frameLength = 1;
  List<File> images = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, Marker> myMarker = {};
  GoogleMapController mapController;
  LatLng initialPosition;
  void _onMapCreated(GoogleMapController controller) async {

    mapController = controller;
    /*CameraUpdate c = CameraUpdate.newLatLngZoom(initialPosition, 16);
    mapController.animateCamera(c);*/
    setState(() {});
  }

  Future getImage(ImageSource source, int index) async {
    var image = await ImagePicker().getImage(source: source);
    setState(() {
     images.insert(index, File(image.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "POST YOUR AD",
            textAlign: TextAlign.center,
            style: googleBtnTextStyle.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          //Todo:change the color according to the theme
          backgroundColor: mPrimaryColor,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  //Todo: Perform the upload ad operation
                }
              },
              child: Container(
                height: 50,
                color: mPrimaryDarkColor,
                child: Center(
                  child: Text(
                    "Post Ad".toUpperCase(),
                    style: googleBtnTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CarouselSlider.builder(
                    itemCount: images.length + 1,
                    itemBuilder: (c, index) {
                      return Container(
                        height: 120,
                        width: size.width,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (_) => makeImageChooser(_, index));

                          },
                          child: _imageUploadBlock(index, size),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      viewportFraction: 0.8,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      autoPlayCurve: Curves.easeInCubic,
                      aspectRatio: 2,
                    ),
                  ),
                  _changeCategoryBlock(context),
                  _buildFormBlock(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageUploadBlock(int index, Size size) {
    if (images.length == 0) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: mPrimaryColor.withOpacity(0.4)
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
        ),
      );
    } else if (images.length < index + 1) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: mPrimaryColor.withOpacity(0.4)
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Image.file(
        images[index],
        width: size.width,
        fit: BoxFit.contain,
      );
    }
  }

  Widget _buildFormBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Title",
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Price",
                prefixText: "\u20B9 ",
              prefixStyle: googleBtnTextStyle.copyWith(fontSize: 17, )
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Description",
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Other Details",
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Mark your address",
            style: googleBtnTextStyle,
          ),
          Container(
            height: 200,
            child: GoogleMap(
              markers: myMarker.values.toSet(),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(26.7569219, 83.346989),
                zoom: 11.0,
              ),
              zoomControlsEnabled: true,
              gestureRecognizers:
              <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              onTap: (latlng) {
                myMarker["default"] = Marker(
                  markerId: MarkerId("default"),
                  position: latlng,
                );

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _changeCategoryBlock(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Testing -> Testing",
            style: googleBtnTextStyle,
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("Discard?"),
                    actions: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No", style: TextStyle(color: Colors.white),),
                        color: mPrimaryColor,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Change >",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 15,
                  color: mPrimaryDarkColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeImageChooser(BuildContext context, int index) {
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
                    getImage(ImageSource.camera, index);
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
                    getImage(ImageSource.gallery, index);
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
