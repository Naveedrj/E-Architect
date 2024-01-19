import 'dart:io';
import 'package:a_architectural_app/profileContollor/Image_controller.dart';
import 'package:a_architectural_app/profileContollor/profileControllor.dart';
import 'package:a_architectural_app/updateProfile.dart';
import 'package:a_architectural_app/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'bottomTabs/bottomTabs.dart';
import 'drawer/drawer_menu.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseStorage firebaseStorage=FirebaseStorage.instance;
  ImageController imageController=Get.put(ImageController());
  final profileController=Get.put(ProfileControllor());
  File? pickedFile;
  late String imageUrlDown;
  bool isEnabled=false;
  ImagePicker imagePicker=ImagePicker();
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  var downloadURL="https://www.pngarts.com/files/6/User-Avatar-in-Suit-PNG.png";

  @override
  void setState(VoidCallback fn) {

    debugPrint(imageUrlDown.toString());
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(ProfileControllor());
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;
    return WillPopScope(child: Scaffold(
        resizeToAvoidBottomInset : false,
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder(
              future: controller.getUserData(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){
                  if(snapshot.hasData){
                    UserModel userData=snapshot.data as UserModel;
                    return  Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              child: FutureBuilder(
                                future: downloadImage(),
                                builder: (context,snapshot){
                                  if(snapshot.connectionState==ConnectionState.done){
                                    return CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage("${downloadURL.toString()}"),
                                      backgroundColor: Colors.white,
                                    );
                                    /*return Image.network(downloadURL.toString(),width: 100,height: 100,);*/
                                  } else {
                                    return CircleAvatar(
                                      backgroundImage: AssetImage('img/profile.png'),
                                      radius: 60,
                                      backgroundColor: Colors.white,
                                    );
                                  }
                                },
                              ),
                            ),
                            /*Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.blueAccent
                                  ),
                                  child: InkWell(
                                    child: Icon(Icons.camera_alt_outlined,color: Colors.white,),
                                    onTap: (){
                                      if(isEnabled==true){
                                        showModalBottomSheet(context: context, builder: (context)=> bottomSheet(context));
                                      }

                                    },
                                  ),
                                ))*/


                          ],
                        ),
                        Form(child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Container(

                              width: w,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  TextFormField(
                                    enabled: isEnabled,
                                    initialValue: userData.fullName,

                                    //  controller: name,
                                    decoration: InputDecoration(
                                        label: Text("Full Name"),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),

                                        prefixIcon: Icon(Icons.perm_identity,color: Colors.blueAccent,)
                                    ),


                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    enabled: isEnabled,
                                    initialValue: userData.phoneNumber,
                                    decoration: InputDecoration(
                                        label: Text("Phone Number"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),

                                        prefixIcon: Icon(Icons.phone,color: Colors.blueAccent,)
                                    ),

                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    enabled: isEnabled,
                                    initialValue: userData.email,
                                    decoration: InputDecoration(
                                        label: Text("Email"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        hintText: "Enter Your Email",
                                        prefixIcon: Icon(Icons.email,color: Colors.blueAccent,)
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  /*  TextFormField(
                                    keyboardType: TextInputType.text,
                                    initialValue: userData.password,
                                    decoration: InputDecoration(
                                        label: Text("Password"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        prefixIcon: Icon(Icons.password_outlined,color: Colors.blueAccent,)
                                    ),
                                  ),*/


                                ],
                              ),
                            ),
                            SizedBox(height: 10.5,),
                            Container(

                              child: SizedBox(
                                height: 60,
                                width: 300,

                                child: ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blueAccent,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)
                                      )

                                  ),

                                  onPressed: () async {
                                    print(userData);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => updateProfile(userData.fullName,userData.phoneNumber,userData.email,userData.password),
                                      ),
                                    );
                                  },

                                  child: const Text('Update Profile',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,

                                    ),

                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: w*0.04,),
                            Container(

                                child: SizedBox(
                                  height: 60,
                                  width: 300,

                                  child: ElevatedButton(

                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blueAccent,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        )

                                    ),

                                    onPressed: () async {
                                      _auth.signOut();
                                      Get.to(()=>LoginPage());

                                    },

                                    child: const Text('Logout',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,

                                      ),

                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ))
                      ],
                    );
                  } else if(snapshot.hasError){
                    return  Center(child: Text(snapshot.error.toString()),);
                  } else {
                    return Center(child: Text("Somthing went Wrong!"),);
                  }
                } else {
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
        )
    ), onWillPop: () async {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) {
        return BottomTabs(selectedIndex: 0);
      }), (route) => false);
      return true;
    });
  }

  Widget bottomSheet(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height*0.15,
      margin: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose Profile Image",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image,size: 30,),
                    SizedBox(height: 5,),
                    Text("Gallery",style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 20
                    ),)
                  ],

                ),
                onTap: (){
                  takePhoto(ImageSource.gallery);
                },
              ),
              SizedBox(width: 70,),
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined,size: 30,),
                    SizedBox(height: 5,),
                    Text("Camera",style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 20
                    ),)
                  ],
                ),
                onTap: (){
                  takePhoto(ImageSource.camera);
                },
              ),

            ],
          ),
        ],
      ),
    );

  }

  Future<void> takePhoto(ImageSource source) async {
    final pickedImage=await imagePicker.pickImage(source: source,imageQuality: 100);
    pickedFile=File(pickedImage!.path);
    debugPrint(pickedImage!.path);
    imageController.setProfileImagePath(pickedFile!.path);
    Reference reference=FirebaseStorage.instance.ref(firebaseAuth.currentUser!.uid).child("ProfileImage").child("profile.png");
    await reference.putFile(File(pickedImage!.path));
     downloadURL=await reference.getDownloadURL();
    Get.back();


  }
  downloadImage() async {
    downloadURL = await FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser!.uid).child("ProfileImage")
        .child("profile.png")
        .getDownloadURL();
  }
}
