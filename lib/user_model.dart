import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {

  final String? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String images;




  const UserModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.images,


});
  toJson(){
    return{
      "FullName":fullName,
      "PhoneNumber": phoneNumber,
      "Email": email,
      "Password": password,
      "Images":images,

    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String , dynamic>> document){
    final data=document.data()!;
    return UserModel(
        id: document.id,
        fullName: data["FullName"],
        phoneNumber: data["PhoneNumber"],
        email: data["Email"],
        password: data["Password"],
        images:data['Images'],


    );
  }




}