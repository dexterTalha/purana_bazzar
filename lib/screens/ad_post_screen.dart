import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:purana_bazzar/helper/helper.dart';
import 'package:purana_bazzar/screens/home_screen.dart';
import '../models/category_model.dart';
import '../utils/constants.dart';

class AdPostScreen extends StatefulWidget {

  final CategoryModel parent, child;
  AdPostScreen({this.parent, this.child});

  @override
  _AdPostScreenState createState() => _AdPostScreenState();
}

class _AdPostScreenState extends State<AdPostScreen> {
  final _titleController = TextEditingController();
  final _descpController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  String address, pincode, uid;
  int imageLength = 0, frameLength = 1;
  List<File> images = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String fuelT;
  bool isUploading = false;

  Map<String, Marker> myMarker = {};
  GoogleMapController mapController;
  LatLng initialPosition, chooseLocation;
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    setState(() {});
    await _getLocation(context);
    myMarker.clear();
    myMarker["default"] = Marker(
      markerId: MarkerId("default"),
      position: initialPosition,
    );
  }


  @override
  void dispose() {
    _titleController.dispose();
    _descpController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  _getLocation(context) async{

    Geolocator _locator = Geolocator();
    Position pos = await _locator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final lat = pos.latitude;
    final lng = pos.longitude;
    CameraUpdate c = CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16);
    mapController.animateCamera(c);
    setState(() {
      initialPosition = LatLng(lat, lng);
      chooseLocation = initialPosition;
    });

  }

  Future<void> _uploadProduct() async{
    if(chooseLocation == null){
      Fluttertoast.showToast(msg: "Please select the location");
      return;
    }
    if(images.length <= 0){
      Fluttertoast.showToast(msg: "Please select atleast one image");
      return;
    }
    User user = FirebaseAuth.instance.currentUser;
    setState(() {
      isUploading = true;
    });
    List<String> add = await HelperClass.getAddressFromCoordinates(chooseLocation);
    address = add[0];
    pincode = add[1];
    final dio = Dio();
    String url = "${baseUrl}insert_ads.php";
    List<String> imageBase64 = [];
    String imagePath = "";
    for(File d in images){
      imageBase64.add(base64Encode(d.readAsBytesSync()));
      String base1 = d.path.split('/').last;
      var aa1 = base1.split(".");
      String ext1 = aa1[1];
      String j = HelperClass().getRandomString(20) + "." + ext1;
      imagePath += j+",";
    }


    Map<String, dynamic> d = {
      "uid": user.uid,
      "category_id": widget.child.id,
      "parent_id": widget.parent.id,
      "title": _titleController.text.trim(),
      "long_des": _descpController.text.trim(),
      "price": _priceController.text.trim(),
      "address": address,
      "zip_code": pincode,
      "image": imageBase64,
      "imagepath": imagePath.trimRight(),
    };
    Response response = await dio.post(url, data: d);
    setState(() {
      isUploading = false;
    });
    var reply = response.data;
    bool st = reply["status"];
    if(!st){
      Fluttertoast.showToast(msg: "Error in uploading! Try again");
      return;
    }
    String msg = reply['msg'];
    String addId = reply['adid'];
    Fluttertoast.showToast(msg: msg);
    showAfterPostDialog(addId);
  }

  Future getImage(ImageSource source, int index) async {
    var image = await ImagePicker().getImage(source: source);
    setState(() {
     images.insert(index, File(image.path));
    });
  }

  void showAfterPostDialog(String adId){
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder:(_) => StatefulBuilder(
        builder:(_, setState) => Material(
          color: Colors.black87,
          child: Container(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("Upgrade Ad To Premium", style: googleBtnTextStyle.copyWith(color: Colors.white),),),
                SizedBox(height: 30,),
                Container(
                  height: 60,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: (){
                      setState((){
                        isUploading = true;
                      });
                    },
                    splashColor: mPrimaryColor,
                    child: Center(child: Text("Upgrade Ad", style: googleBtnTextStyle.copyWith(color: Colors.white),),),
                  ),
                ),
                SizedBox(height: 60,),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> HomeScreen()), (b) => false);
                    },
                    child: Text(
                      "No Thanks",
                      style: googleBtnRegularTextStyle.copyWith(color: Colors.white, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: LoadingOverlay(
        isLoading: isUploading,
        color: Colors.black87,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        opacity: 0.8,
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
                onTap: () async{
                  //showAfterPostDialog("addId");
                  if (_formKey.currentState.validate()) {
                    await _uploadProduct();
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
          body: WillPopScope(
            onWillPop: (){
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
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> HomeScreen()), (b) => false);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  );
                },
              );

              return Future.value(true);
            },
            child: SafeArea(
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
                        itemCount: images.length == 4?images.length:images.length + 1,
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
                          viewportFraction: 0.7,
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
            controller: _titleController,
            validator: (st){
              if(st.isEmpty){
                return "Please enter title";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Title",
            ),
          ),
          SizedBox(height: 10),
          widget.parent.id == "1"? TextFormField(
            validator: (st){
              if(st.isEmpty){
                return "Please enter brand";
              }
              return null;
            },
            controller: _brandController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Brand/Model",
            ),
          ):Container(),
          widget.parent.id == "1"? SizedBox(height: 10):Container(),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _priceController,
            validator: (st){
              if(st.isEmpty){
                return "Please enter price";
              }
              return null;
            },
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
            validator: (st){
              if(st.isEmpty){
                return "Please enter description";
              }
              return null;
            },
            controller: _descpController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Description",
            ),
          ),

          widget.parent.id=="2"? SizedBox(height: 10) : Container(),
          widget.parent.id=="2"? _buildCarForm() : Container(),

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
                target: initialPosition ?? LatLng(26.7569219, 83.346989),
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
                setState(() {
                  chooseLocation = latlng;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarForm(){
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 3.0,
            right: 3,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: 5.0, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<String>(
              underline: Container(),
              isExpanded: true,
              value: fuelT,
              hint: Text("Select Fuel Type"),
              items:
              fuelType.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                  key: Key(value),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  fuelT = v;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Year",
              prefixStyle: googleBtnTextStyle.copyWith(fontSize: 17, )
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "KM Driven",
              suffixText: "KM",
              prefixStyle: googleBtnTextStyle.copyWith(fontSize: 17, )
          ),
        ),
        SizedBox(height: 10),
      ],
    );

  }

  Widget _changeCategoryBlock(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${widget.parent.name}-> ${widget.child.name}",
              style: googleBtnTextStyle,
            ),
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
