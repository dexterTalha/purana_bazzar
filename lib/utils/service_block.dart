import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class ServiceBlock extends StatelessWidget {

  final String id, title, url;


  ServiceBlock({@required this.id, @required this.title, @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          child: Stack(
            children: [
              Container(
                height: 250,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: mPrimaryColor, width: 2)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    height: 210,
                    width: 210,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.black38
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 30),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(title, textAlign: TextAlign.center, style: googleBtnTextStyle.copyWith(color: Colors.white),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

