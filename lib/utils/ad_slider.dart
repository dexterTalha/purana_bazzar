import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class AdSliderBlock extends StatefulWidget {
  @override
  _AdSliderBlockState createState() => _AdSliderBlockState();
}

class _AdSliderBlockState extends State<AdSliderBlock> {
  int _current = 0;
  final List<Map<String, dynamic>> imgList = [
    {
      'index': 0,
      'title': 'Title 1',
      'image':
          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    },
    {
      'index': 1,
      'title': 'Title 2',
      'image':
          'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    },
    {
      'index': 2,
      'title': 'Title 3',
      'image':
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    },
    {
      'index': 3,
      'title': 'Title 4',
      'image':
          'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider(
            items: List.generate(imgList.length, (index) {
              return Container(
                child: CachedNetworkImage(
                  imageUrl: imgList[index]['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }),
            options: CarouselOptions(
                scrollPhysics: BouncingScrollPhysics(),
                pageSnapping: false,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayCurve: Curves.easeInCubic,
                aspectRatio: 16 / 9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width * 0.35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((url) {
                int index = url['index'];
                return Container(
                  width: 15.0,
                  height: 15.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _current == index ? mPrimaryDarkColor : Colors.black87,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
