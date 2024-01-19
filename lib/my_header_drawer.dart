import 'package:a_architectural_app/profileContollor/Image_controller.dart';
import 'package:a_architectural_app/profileContollor/profileControllor.dart';
import 'package:a_architectural_app/userRepository/user_repository.dart';
import 'package:a_architectural_app/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MyHeaderDrawer extends StatefulWidget {

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();

}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  ImageController imageController=Get.put(ImageController());
  UserRepository userRepo=Get.put(UserRepository());
  ProfileControllor profileControllor=Get.put(ProfileControllor());
  var downloadURL="https://www.pngarts.com/files/6/User-Avatar-in-Suit-PNG.png";
  final controller=Get.put(ProfileControllor());
  final _db=FirebaseFirestore.instance;
  String _email='xyz@abc.com';
  String name='NoName';
  @override
  Widget build(BuildContext context) {
    final email=firebaseAuth.currentUser?.email;
    getUserDetails(email!);
    return Container(

      color: Colors.blueAccent,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: FutureBuilder(
              future: downloadImage(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){
                  return CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage("${downloadURL.toString()}"),
                    backgroundColor: Colors.white,
                  );
                 /*return Image.network(downloadURL.toString(),width: 100,height: 100,);*/
                } else {
                  return CircleAvatar(
                    backgroundImage: AssetImage('img/profile.png'),
                    radius: 45,
                    backgroundColor: Colors.white,
                  );
                }
              },
            ),
          ),
          Container(
            child: FutureBuilder(
                  future: controller.getUserData(),
                  builder: (context,snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        UserModel userData = snapshot.data as UserModel;
                        return Column(
                          children: [
                            Form(child: Column(
                              children: [
                                Text(userData.fullName,style: TextStyle(color: Colors.white,fontSize: 15),),
                                Text(userData.email, style: TextStyle(color: Colors.grey[200],fontSize: 12),),
                              ],
                            ))
                          ],
                        );
                      }
                    }
                    return Text("No widget to build");
                  }
                )
          ),

        ],

      ),
    );


  }

    getUserDetails(String email) async{
    final snapshot= await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData=snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    name=userData.fullName;
    _email=userData.email;
  }
  downloadImage() async {
    downloadURL = await FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser!.uid).child("ProfileImage")
        .child("profile.png")
        .getDownloadURL();
  }


}
