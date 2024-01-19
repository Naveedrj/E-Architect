import 'package:a_architectural_app/profileContollor/Image_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:a_architectural_app/AuthRepository/AuthRepository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../userRepository/user_repository.dart';
import '../user_model.dart';

class ProfileControllor extends GetxController {
  static ProfileControllor get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final authRepo = Get.put(AuthRepository());
  final userRepo = Get.put(UserRepository());
  ImageController imageController = Get.put(ImageController());

  String? downloadImageUrl;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String name;
  late String _email;
  File? pickedFile;
  String? imageUrlDown = null;
  ImagePicker imagePicker = ImagePicker();


  getUserData() {
    final email = auth.currentUser?.email;
    if (email != null) {
      return userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to Continue");
    }
  }

  getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where(
        "Email", isEqualTo: email).get();
    final userData = snapshot.docs
        .map((e) => UserModel.fromSnapshot(e))
        .single;
    name = userData.fullName;
    _email = userData.email;
  }

  /*Future getData() async{
    try{
      await downloadUrl();
      return downloadImageUrl;
    } catch(e){
      debugPrint("Error:$e");
      return null;
    }
  }*/

  /*Future<List<String>> getFirebaseImageFolder() async {
    List<String> finalResult=['https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'];
    final Reference storageRef = FirebaseStorage.instance.ref(FirebaseAuth.instance.currentUser?.uid).child('GeneratedImage');
    storageRef.listAll().then((result) {
      debugPrint("result is $result");
      finalResult=result.items.toString() as List<String>;
      debugPrint(finalResult.toString());
      return finalResult;
    });
    return finalResult;
  }*/
  /*static Future<List<String>> fetchImages(
      String uniqueUserId) async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser?.uid)
        .child('GeneratedImage')
        .list();
    final List<Reference> allFiles = result.items;
   // print(allFiles.length);

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
     // print('result is $fileUrl');

      files.add({
        'url': fileUrl,
        'path': file.fullPath,
        'uploaded_by': fileMeta.customMetadata!['uploaded_by'] ?? 'Nobody',
        'description':
        fileMeta.customMetadata!['description'] ?? 'No description'
      });
    });
    List<String> streetsList = new List<String>.from(files);
    return streetsList;
  }*/
}