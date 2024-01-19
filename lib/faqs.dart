import 'package:flutter/material.dart';

import 'bottomTabs/bottomTabs.dart';
import 'drawer/drawer_menu.dart';
class Faqs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text('FAQs'),
      ),
    ), onWillPop: () async {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) {
        return BottomTabs(selectedIndex: 0);
      }), (route) => false);
      return true;
    });
  }
}
