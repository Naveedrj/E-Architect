

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:a_architectural_app/Models/ftsd.dart';
import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';
import 'package:a_architectural_app/home.dart';
import 'package:a_architectural_app/membership.dart';
import 'package:a_architectural_app/profileContollor/profileControllor.dart';
import 'package:a_architectural_app/userRepository/user_repository.dart';
import 'package:a_architectural_app/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'Models/ftsdcopy.dart';
import 'Models/rsd.dart';
import 'drawer/drawer_menu.dart';
import 'generate.dart';
class newDesigns extends StatefulWidget {
  @override
  State<newDesigns> createState() => _newDesignsState();
}

class _newDesignsState extends State<newDesigns> {
  final length=TextEditingController();

  final width=TextEditingController();

  final bedrooms=TextEditingController();

  final washrooms=TextEditingController();
  final dining=TextEditingController();

  final living=TextEditingController();
  bool gerag=false;
  bool lawn=false;
  int geragV=0;
  int lawnV=0;
  int count=0;
  bool stair=false;
  int stairV=0;
  String coins="0";

  final GlobalKey<FormState> _formKey=  GlobalKey<FormState>();
  List<String> listItems=["Raw Stable Diffusion","FTSD-400","FTSD-1200","FTSD-1500"];
  String selectedItem="Raw Stable Diffusion";
  @override
  void dispose() {
    length.dispose();
    width.dispose();
    bedrooms.dispose();
    washrooms.dispose();
    dining.dispose();
    living.dispose();
    // TODO: implement dispose
  }
  final controller=Get.put(ProfileControllor());
  late QuerySnapshot querySnapshots;

  Future<String?> findImagesByEmail() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;

        // Check if the 'Images' field exists in the document data
        if (userData.containsKey('Images')) {
          String imagesUrl = userData['Images'];
          print("gift/"+imagesUrl);// Assuming 'Images' is a String
          return imagesUrl;
        } else {
          print('Images not found in document.');
          return null;
        }
      } else {
        print('Document not found.');
        return null;
      }
    } catch (e) {
      print('Error finding document: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;

    return WillPopScope(child: Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: Text('New Designs'),
        ),
        body: SingleChildScrollView(
          child: Expanded(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20,right: 20),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(

                          child: Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'New Designs',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.blueAccent
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.only(left: 5,bottom: 5),
                          child: Row(
                            children: [
                              Text("Model: ",style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontSize: 15

                              ),),
                              SizedBox(width: 10,),
                              DropdownButton(
                                   hint: Text("Select Model"),
                                  value: selectedItem,
                                  items:listItems.map<DropdownMenuItem<String>>((String e){
                                    return DropdownMenuItem(
                                        value: e,
                                        child: Text(e));
                                  }).toList(),
                                  onChanged: (val){
                                    setState((){
                                         selectedItem=val as String;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.only(left: 5,bottom: 5),
                          child: const Text(
                            'Length:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: length,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter length";
                            }
                            if(int.parse(value)<25 || int.parse(value)>120){
                              return "please enter length greater then 25 and less then 120";
                            }
                            return null;
                          },
                          decoration: InputDecoration(

                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter Length",
                              prefixIcon: const Icon(Icons.area_chart_outlined,color: Colors.blueAccent,)
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          margin: const EdgeInsets.only(left: 5,bottom: 5),
                          child: const Text(
                            'Width:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: width,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter width";
                            }
                            if(int.parse(value)<25 || int.parse(value)>120){
                              return "please enter width greater then 25 and less then 120";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter Width",
                              prefixIcon: const Icon(Icons.area_chart,color: Colors.blueAccent,)
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          margin: const EdgeInsets.only(left: 5,bottom: 5),
                          child: const Text(
                            'Bedrooms:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: bedrooms,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter no of bedrooms";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter Number of Bedrooms",
                              prefixIcon: const Icon(Icons.bed,color: Colors.blueAccent,)
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          margin: const EdgeInsets.only(left: 5,bottom: 5),
                          child: const Text(
                            'Washrooms:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: washrooms,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter no of washrooms";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter number of Washrooms",
                              prefixIcon: const Icon(Icons.wash,color: Colors.blueAccent,)

                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          margin: const EdgeInsets.only(left: 5,bottom: 5),
                          child: const Text(
                            'Dining Room:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: dining,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter no of Dining Rooms";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter number of Dining Rooms",
                              prefixIcon: const Icon(Icons.table_restaurant_sharp,color: Colors.blueAccent,)

                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          margin: const EdgeInsets.only(left: 5,bottom: 5),
                          child: const Text(
                            'Living Room:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: living,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter no of Living Rooms";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter number of Living Rooms",
                              prefixIcon: const Icon(Icons.tv,color: Colors.blueAccent,)

                          ),
                        ),

                        Row(
                          children: [
                            Checkbox(value: gerag, onChanged: (bool? value){
                              setState(() {
                                gerag=value!;
                                if(gerag==true){
                                  geragV=1;
                                } else{
                                  geragV=0;
                                }
                              });
                            }),
                            Text("Garage")

                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: lawn, onChanged: (bool? value){
                              setState(() {
                                lawn=value!;
                                if(lawn==true){
                                  lawnV=1;
                                } else{
                                  lawnV=0;
                                }
                              });
                            }),
                            Text("Lawn")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: stair, onChanged: (bool? value){
                              setState(() {
                                stair=value!;
                                if(stair==true){
                                  stairV=1;
                                } else{
                                  stairV=0;
                                }
                              });
                            }),
                            Text("Stair")

                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(
                              child: SizedBox(
                                height: 60,
                                width: 300,
                                child: ElevatedButton( style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    )
                                ),onPressed: () async {
                                  String? data=await findImagesByEmail();
                                  print(data);
                                  if(data==null || int.parse(data.toString())<1){
                                    _showSimpleDialogs();
                                  } else{
                                  if (_formKey.currentState!.validate())  {
                                    int l = int.parse(length.text.toString());
                                    int w = int.parse(width.text.toString());
                                    int square = l + w;
                                    int b = int.parse(
                                        bedrooms.text.toString()) * 10;
                                    int wash = int.parse(
                                        washrooms.text.toString()) * 5;
                                    int livin = int.parse(
                                        living.text.toString()) * 5;
                                    int din = int.parse(
                                        dining.text.toString()) * 5;
                                    int la = 0;
                                    int g = 0;
                                    int s = 0;
                                    if (lawn == true) {
                                      setState(() {
                                        la = 5;
                                      });
                                    }
                                    if (stair == true) {
                                      setState(() {
                                        s = 5;
                                      });
                                    }
                                    if (gerag == true) {
                                      setState(() {
                                        g = 5;
                                      });
                                    }
                                    if (l == w) {
                                      int sum = b + wash + livin + din + la +
                                          g + s;

                                      if (_formKey.currentState!.validate() &&
                                          square >= sum) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Please Wait...')),
                                        );
                                        // Get.to(()=>Generate(length.text.trim(),width.text.trim(),bedrooms.text.trim(),washrooms.text.trim()));
                                        if (selectedItem ==
                                            "Raw Stable Diffusion") {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) {
                                                return RSD(
                                                    length,
                                                    width,
                                                    bedrooms,
                                                    washrooms,
                                                    dining,
                                                    living,
                                                    geragV,
                                                    lawnV,
                                                    stairV,
                                                    int.parse(data.toString()));
                                              }));
                                        } else
                                        if (selectedItem == "FTSD-400") {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) {
                                                return ftsd(
                                                    length,
                                                    width,
                                                    bedrooms,
                                                    washrooms,
                                                    dining,
                                                    living,
                                                    geragV,
                                                    lawnV,
                                                    stairV,
                                                    "FTSD-200/200",
                                                    int.parse(data.toString()));
                                              }));
                                        } else
                                        if (selectedItem == "FTSD-1200") {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) {
                                                return ftsd(
                                                    length,
                                                    width,
                                                    bedrooms,
                                                    washrooms,
                                                    dining,
                                                    living,
                                                    geragV,
                                                    lawnV,
                                                    stairV,
                                                    "FTSD-600/200",
                                                    int.parse(data.toString()));
                                              }));
                                        } else
                                        if (selectedItem == "FTSD-1500") {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) {
                                                return ftsd(
                                                    length,
                                                    width,
                                                    bedrooms,
                                                    washrooms,
                                                    dining,
                                                    living,
                                                    geragV,
                                                    lawnV,
                                                    stairV,
                                                    "FTSD-1200/400",
                                                    int.parse(data.toString()));
                                              }));
                                        }
                                      } else {
                                        _showSimpleDialog();
                                      }
                                    } else {
                                      if (_formKey.currentState!.validate()) {
                                        /*ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Complete Please Wait...')),
                                        );*/
                                        // Get.to(()=>Generate(length.text.trim(),width.text.trim(),bedrooms.text.trim(),washrooms.text.trim()));
                                        if (selectedItem ==
                                            "Raw Stable Diffusion") {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) {
                                                return RSD(
                                                    length,
                                                    width,
                                                    bedrooms,
                                                    washrooms,
                                                    dining,
                                                    living,
                                                    geragV,
                                                    lawnV,
                                                    stairV,
                                                    int.parse(data.toString()));
                                              }));
                                        } else
                                        if (selectedItem == "FTSD-400") {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) {
                                                return ftsd(
                                                    length,
                                                    width,
                                                    bedrooms,
                                                    washrooms,
                                                    dining,
                                                    living,
                                                    geragV,
                                                    lawnV,
                                                    stairV,
                                                    "FTSD-200/200",
                                                    int.parse(data.toString()));
                                              }));
                                        } else
                                        if (selectedItem == "FTSD-1200") {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) {
                                                return ftsd(
                                                    length,
                                                    width,
                                                    bedrooms,
                                                    washrooms,
                                                    dining,
                                                    living,
                                                    geragV,
                                                    lawnV,
                                                    stairV,
                                                    "FTSD-600/200",
                                                    int.parse(data.toString()));
                                              }));
                                        } else
                                        if (selectedItem == "FTSD-1500") {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) {
                                                return ftsd(
                                                    length,
                                                    width,
                                                    bedrooms,
                                                    washrooms,
                                                    dining,
                                                    living,
                                                    geragV,
                                                    lawnV,
                                                    stairV,
                                                    "FTSD-1200/400",
                                                    int.parse(data.toString()));
                                              }));
                                        }
                                      } else {
                                        _showSimpleDialog();
                                      }
                                    }
                                  } else {
                                    _showSimpleDialog();
                                  }
                                  }
                                  }, child: Text(
                                  'Next',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                              )
                          ),
                        ),
                        SizedBox(height: 20,)

                      ],
                    ),
                  ),)
              ],
            ),
          ),
        )
    ), onWillPop: () async {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) {
        return BottomTabs(selectedIndex: 0);
      }), (route) => false);
      //TapGestureRecognizer()..onTap=()=>Get.back();
       return true;
    });
  }
 _showSimpleDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog( // <-- SEE HERE
            title: Text("Warning!"),
            content: Text("Please Enter Correct Information"),
           actions: <Widget>[
             TextButton(onPressed:() {
               Navigator.of(context).pop();
             }, child: Center(child: const Text('close',style: TextStyle(

             ),)),)
            ],
          );
        });
  }
  _showSimpleDialogs() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog( // <-- SEE HERE
            title: const Text("No credit!"),
            content: const Text("Please Upgrade your plan"),
            actions: <Widget>[
              TextButton(onPressed:() {
                Navigator.of(context).pop();
              }, child: const Center(child: Text('close',style: TextStyle(

              ),)),),
              TextButton(onPressed:() {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return const MemberShip();
                }));
              }, child: const Center(child: Text('Upgrade plan',style: TextStyle(

              ),)),)
            ],
          );
        });
  }
}


