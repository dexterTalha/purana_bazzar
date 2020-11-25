import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../fragments/messages/all_messages.dart';
import '../fragments/messages/buying_message.dart';
import '../fragments/messages/selling_message.dart';
import '../utils/constants.dart';

class MessageFragment extends StatefulWidget {
  @override
  _MessageFragmentState createState() => _MessageFragmentState();
}

class _MessageFragmentState extends State<MessageFragment> with SingleTickerProviderStateMixin {
  final _messagePages = [AllMessagesFragment(), BuyingMessagesFragment(), SellingMessagesFragment()];

  int _currentPage = 0;
  TabController _tabController;

  final _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _messagePages.length, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: tabBuilder((index) {
              setState(() {
                _currentPage = index;
                _pageController.animateToPage(
                  _currentPage,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              });
            }),
          ),
          Expanded(
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _tabController.animateTo(_currentPage);
                });
              },
              itemBuilder: (_, index) {
                return  _messagePages[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBuilder(Function(int) _onTap) {
    return TabBar(
      onTap: _onTap,
      controller: _tabController,
      unselectedLabelColor: mPrimaryDarkColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: mPrimaryDarkColor,
      ),
      tabs: [
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: mPrimaryDarkColor, width: 1),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text("ALL"),
            ),
          ),
        ),
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: mPrimaryDarkColor, width: 1),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text("BUYING"),
            ),
          ),
        ),
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: mPrimaryDarkColor, width: 1),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text("SELLING"),
            ),
          ),
        ),
      ],
    );
  }
}
