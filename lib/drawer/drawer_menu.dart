import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';

import 'package:a_architectural_app/new_designs.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../my_header_drawer.dart';


class DrawerMenu extends StatefulWidget {
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();

}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: MyHeaderDrawer()),
          ListTile(
            leading: Icon(Icons.home,color: Colors.grey[700],),
            title: Text('Home',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabs(selectedIndex:0)));
            },
          ),
          ListTile(
            leading: Icon(Icons.search,color: Colors.grey[700],),
            title: Text('Search Designs',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabs(selectedIndex:1)));
            },
          ),
          ListTile(
            leading: Icon(Icons.save,color: Colors.grey[700],),
            title: Text('Saved Designs',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabs(selectedIndex:2)));
            },
          ),
          ListTile(
            leading: Icon(Icons.person,color: Colors.grey[700],),
            title: Text('Profile',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabs(selectedIndex:3)));
            },
          ),
          ListTile(
            leading: Icon(Icons.add_rounded,color: Colors.grey[700],),
            title: Text('New Design',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>newDesigns()));
            },
          ),
           ListTile(
             leading: Icon(Icons.wallet_membership,color: Colors.grey[700],),
             title: Text('Membership',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
             onTap: (){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabs(selectedIndex:5)));
             },
           ),

          ListTile(
            leading: Icon(Icons.policy,color: Colors.grey[700],),
            title: Text('Privacy Policy',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabs(selectedIndex:6)));
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer,color: Colors.grey[700],),
            title: Text('FAQs',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabs(selectedIndex:7)));
            },
          )

        ],
      ),

    );

  }
}

