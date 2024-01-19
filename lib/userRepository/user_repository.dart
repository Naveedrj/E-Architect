import 'package:a_architectural_app/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();
  final _db=FirebaseFirestore.instance;
  User? users = FirebaseAuth.instance.currentUser;

  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson()).whenComplete(() => Get.snackbar(
      "Success", "Your Account has been created",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blueAccent.withOpacity(0.1),
      colorText: Colors.blueAccent,)
    )
    .catchError((error,stackTrace){
      Get.snackbar("error", "Something Went wrong",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red);
      print(error.toString());
    });
  }
  Future<void> updateUser( UserModel user) async {
    try {
      if (user != null) {
        String userId = users!.uid;

        await _db.collection("Users").doc(userId).set(user.toJson());

        Get.snackbar(
          "Success",
          "Your Account has been updated",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          colorText: Colors.blueAccent,
        );
      } else {
        print("No userid found");
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    }
  }
  Future<UserModel> getUserDetails(String email) async{
    final snapshot= await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData=snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }
}