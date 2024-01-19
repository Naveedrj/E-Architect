import 'package:a_architectural_app/faqs.dart';
import 'package:a_architectural_app/home.dart';
import 'package:a_architectural_app/membership.dart';
import 'package:a_architectural_app/new_designs.dart';
import 'package:a_architectural_app/privacy_policy.dart';
import 'package:a_architectural_app/profile.dart';
import 'package:a_architectural_app/saved_designs.dart';
import 'package:a_architectural_app/search_designs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'my_header_drawer.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var currentPage=DrawerSection.home;
  int _currentState=0;
  final List<Widget> pages=[
    Home(),
    SearchDesigns(),
    newDesigns(),
    SavedDesigns()
  ];
  @override
  Widget build(BuildContext context) {
    var container;
    if(currentPage==DrawerSection.home){
      container=Home();
    } else if(currentPage==DrawerSection.search_designs){
      container=SearchDesigns();
    } else if(currentPage==DrawerSection.saved_designs){
      container=SavedDesigns();
    } else if(currentPage==DrawerSection.new_designs){
      container=newDesigns();
    } /*else if(currentPage==DrawerSection.membership){
      container=Membership();
    }*/ else if(currentPage==DrawerSection.privacy_policy){
      container=PrivacyPolicy();
    } else if(currentPage==DrawerSection.faqs){
      container=Faqs();
    }
      return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: pages[_currentState],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentState,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blueAccent,
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.blueAccent
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Generate',
              backgroundColor: Colors.blueAccent
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.storage),
              label: 'Repository',
              backgroundColor: Colors.blueAccent
          ),
        ],
        onTap: (index){
          setState(() {
            _currentState=index;
            /*if(index==0){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> homePage()));
            } else if(index==1){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchDesigns()));
            } else if(index==2){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> newDesigns()));
            } else if(index==3){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SavedDesigns()));
            }*/
          });
        },
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget MyDrawerList(){
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          menuItem(1,"Home",Icons.home,currentPage==DrawerSection.home? true:false),
          menuItem(2,"Search Designs",Icons.search,currentPage==DrawerSection.search_designs? true:false),
          menuItem(3,"Saved Designs",Icons.save,currentPage==DrawerSection.saved_designs? true:false),
          menuItem(4,"New Designs",Icons.add_rounded,currentPage==DrawerSection.new_designs? true:false),
          /*menuItem(5,"Membership",Icons.card_membership,currentPage==DrawerSection.membership? true:false),*/
          menuItem(5,"Privacy Policy",Icons.policy,currentPage==DrawerSection.privacy_policy? true:false),
          menuItem(6,"Faqs",Icons.question_answer,currentPage==DrawerSection.faqs? true:false),

        ],
      ),
    );
  }
  Widget menuItem(int id,String title,IconData icon,bool selected){
    return Material(
      color: selected ? Colors.grey[300]:Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
          setState(() {
            if(id==1){
              currentPage=DrawerSection.home;
            } else if(id==2){
              currentPage=DrawerSection.search_designs;
            } else if(id==3){
              currentPage=DrawerSection.saved_designs;
            } else if(id==4){
              currentPage=DrawerSection.new_designs;
            } /*else if(id==5){
              currentPage=DrawerSection.membership;
            }*/ else if(id==6){
              currentPage=DrawerSection.privacy_policy;
            } else if(id==7){
              currentPage=DrawerSection.faqs;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(child:
              Icon(
                icon,
                size: 25,
                color: Colors.grey[700],
              )
              ),
              Expanded(flex: 3,child: Text(
                title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey[700]),)),
            ],
          ),
        ),
      ),
    );
  }
}
enum DrawerSection{
  home,
  search_designs,
  saved_designs,
  new_designs,
 /* membership,*/
  privacy_policy,
  faqs,
}
