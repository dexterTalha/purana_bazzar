import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purana_bazzar/utils/message_block.dart';

class SellingMessageFragment extends StatefulWidget {
  @override
  _SellingMessageFragmentState createState() => _SellingMessageFragmentState();
}

class _SellingMessageFragmentState extends State<SellingMessageFragment> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            closeOnScroll: true,
            secondaryActions: [
              IconSlideAction(
                closeOnTap: true,
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete_outline,
                onTap: () {
                  Fluttertoast.showToast(msg: "Delete");
                },
              ),
            ],
            child: MessageBlock(),
          ),
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            closeOnScroll: true,
            secondaryActions: [
              IconSlideAction(
                closeOnTap: true,
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete_outline,
                onTap: () {
                  Fluttertoast.showToast(msg: "Delete");
                },
              ),
            ],
            child: MessageBlock(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
