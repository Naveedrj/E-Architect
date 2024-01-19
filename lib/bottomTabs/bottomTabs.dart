import 'package:a_architectural_app/faqs.dart';
import 'package:a_architectural_app/home.dart';
import 'package:a_architectural_app/membership.dart';
import 'package:a_architectural_app/my_header_drawer.dart';
import 'package:a_architectural_app/new_designs.dart';
import 'package:a_architectural_app/privacy_policy.dart';
import 'package:a_architectural_app/profile.dart';
import 'package:a_architectural_app/saved_designs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../search_designs.dart';

class BottomTabs extends StatefulWidget {
int selectedIndex=0;
BottomTabs({required this.selectedIndex});
  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int currentindex=0;
  void onItemTapped(int index){
    setState(() {
      widget.selectedIndex=index;
      currentindex=widget.selectedIndex;
    });
  }
  @override
  void initState(){
    onItemTapped(widget.selectedIndex);
    super.initState();
  }
  final List<Widget> pages=[
    Home(),
    SearchDesigns(),
    SavedDesigns(),
    ProfilePage(),
    newDesigns(),
    MemberShip(),
    PrivacyPolicy(),
    Faqs(),



  ];
  final PageStorageBucket bucket=PageStorageBucket();


  @override
  Widget build(BuildContext context) {
    Widget currentScreen= currentindex==0 ?Home(): currentindex==1? SearchDesigns():currentindex==2? SavedDesigns() : currentindex==3? ProfilePage() :currentindex==4? newDesigns():currentindex==5? MemberShip():currentindex==6? PrivacyPolicy():Faqs();


    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> newDesigns()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentindex = 0;
                        currentScreen = Home();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentindex==0? Colors.blueAccent:Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(color: currentindex==0? Colors.blueAccent:Colors.grey),
                        )
                      ],
                    ),

                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentindex = 1;
                        currentScreen = SearchDesigns();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: currentindex==1? Colors.blueAccent:Colors.grey,
                        ),
                        Text(
                          'Search',
                          style: TextStyle(color: currentindex==1? Colors.blueAccent:Colors.grey),
                        )
                      ],
                    ),

                  )
                ],
              ),
              Row(
                children: [
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentindex = 2;
                        currentScreen = SavedDesigns();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save,
                          color: currentindex==2? Colors.blueAccent:Colors.grey,
                        ),
                        Text(
                          'Repository',
                          style: TextStyle(color: currentindex==2? Colors.blueAccent:Colors.grey),
                        )
                      ],
                    ),

                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentindex = 3;
                        currentScreen = ProfilePage();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentindex==3? Colors.blueAccent:Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(color: currentindex==3? Colors.blueAccent:Colors.grey),
                        )
                      ],
                    ),

                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
