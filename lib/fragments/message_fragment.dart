import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/no_data_screen.dart';

class MessageFragment extends StatefulWidget {
  @override
  _MessageFragmentState createState() => _MessageFragmentState();
}

class _MessageFragmentState extends State<MessageFragment> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: NoDataScreen(
        assetName: 'assets/png/no_message.png',
      ),
    );
  }
}
