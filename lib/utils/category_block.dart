import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../screens/ad_post_screen.dart';
import '../screens/property_ad_post_screen.dart';
import '../utils/constants.dart';

class CategoryBlock extends StatelessWidget {

  final bool isPostAd;
  final List<CategoryModel> childrenCat;
  final CategoryModel parent;


  CategoryBlock({this.isPostAd = false, @required this.childrenCat, @required this.parent});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: mPrimaryColor.withOpacity(0.4),
      onTap: () {
        showChildCatDialog(context);
      },
      child: Container(
        height: 180,
        width: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.2),
              Colors.blue.withOpacity(0.1),
              Colors.blue.withOpacity(0.05),
            ],
            end: Alignment.topRight,
            begin: Alignment.bottomLeft
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: parent.image,
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                parent.name,
                overflow: TextOverflow.ellipsis,
                style: googleBtnTextStyle.copyWith(fontSize: isPostAd? 18:14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showChildCatDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      elevation: 8,
      title: Text(
        parent.name,
        style: googleBtnTextStyle,
      ),
      content: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              childrenCat.length,
            (index) => ListTile(
              onTap: () {
                if (isPostAd) {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute<Null>(
                      builder: (_) => parent.id == "6"
                          ? PropertyAdPostScreen(
                              child: childrenCat[index],
                              parent: parent,
                            )
                          : AdPostScreen(
                              child: childrenCat[index],
                              parent: parent,
                            ),
                    ),
                  );
                } else {}
              },
              title: Text(childrenCat[index].name),
            ),
          ),
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setState) => dialog,
      ),
    );
  }
}
