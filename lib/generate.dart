import 'dart:io';

import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';
import 'package:a_architectural_app/saved_designs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
class Generate extends StatelessWidget {
  var length;
  var width;
  var bedrooms;
  var washrooms;
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseStorage storage=FirebaseStorage.instance;
  FirebaseDatabase firebaseDatabase=FirebaseDatabase.instance;
  ImagePicker imagePicker=ImagePicker();


  Generate(length,width,bedrooms,washrooms){
     this.length=length;
     this.width=width;
     this.bedrooms=bedrooms;
     this.washrooms=washrooms;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              width: 400,
              height: 400,
              child: Image(image: AssetImage("img/25x45 plan with 2 bedrooms 2 washrooms 1 living 1 dining 1 kitchen.jpeg")),
            ),
          ),
          Center(
            child: Column(
              children: [
                Center(
                  child: Row(
                    children: [
                      SizedBox(width: 25,),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Center(
                            child: SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton( style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )
                              ),onPressed: (){
                                Savedplan();
                              }, child: Text(
                                'Save plan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )),
                            )
                        ),
                      ),
                      SizedBox(width: 10,),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Center(
                            child: SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton( style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )
                              ),onPressed: (){


                              }, child: Text(
                                'Regenerate',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      SizedBox(width: 100,),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Center(
                            child: SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton( style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )
                              ),onPressed: (){
                                Get.back();
                              }, child: Text(
                                'Edit Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )),
                            )
                        ),
                      ),


                    ],
                  ),
                ),




              ],
            ),
          )

        ],
      ),
    );
  }

  Future<void> Savedplan() async {
    final pickedImage="img/btn.png";
    var imageNam="btn.png";
    debugPrint(imageNam);
    Reference reference=FirebaseStorage.instance.ref(auth.currentUser!.uid).child("GeneratedImage").child(imageNam);
    await reference.putString(pickedImage);
    //await Get.to(()=>BottomTabs(selectedIndex: 2));
  }
}
