import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../userRepository/user_repository.dart';
import '../user_model.dart';

class AuthRepository{
  final userRepo=Get.put(UserRepository());
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Future<String?> signIn(String email,String password) async{
    try{
      UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        return "No User Exist with this Email";
      } else if (e.code == 'wrong-password') {
        //print('The account already exists for that email.');
        return "Wrong Password";
      }
    } catch (e) {
      return e.toString();
    }
  }
  Future<String?> signUp(String fullName,String PhoneNumber,String email,String password,String images) async{

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

     // firebaseUser=Rx<User?>(auth.currentUser);
      final user=UserModel(fullName: fullName, phoneNumber: PhoneNumber, email: email, password: password,images: images);
      await userRepo.createUser(user);
      const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        //print('The account already exists for that email.');
        return "Email Already in Used";
      }
    } catch (e) {
      return e.toString();
    }
    return null;

  }
  Future<String?> update(String fullName,String PhoneNumber,String email,String password,String images) async{

    try {
      // firebaseUser=Rx<User?>(auth.currentUser);
      final user=UserModel(fullName: fullName, phoneNumber: PhoneNumber, email: email, password: password,images: images);
      await userRepo.updateUser(user);
      const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        //print('The account already exists for that email.');
        return "Email Already in Used";
      }
    } catch (e) {
      return e.toString();
    }
    return null;

  }



}