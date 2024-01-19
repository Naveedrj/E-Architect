import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ImageController extends GetxController{
  var isProficPicPathSet=false.obs;
  var isFireProficPicPathSet=false.obs;
  String? downloadImageUrl;
  var profilePicPath="".obs;
  void setProfileImagePath(String path){
    profilePicPath.value=path;
    isProficPicPathSet.value=true;
  }
  setFireProfileImagePath() async {
    await getData();
    isFireProficPicPathSet.value=true;
    return true;
  }
  Future getData() async{
    try{
      await downloadUrl();
      isFireProficPicPathSet.value=true;
      return downloadImageUrl;
    } catch(e){
      debugPrint("Error:$e");
      return null;
    }
  }

  Future<void> downloadUrl() async {
    downloadImageUrl=await FirebaseStorage.instance.ref(FirebaseAuth.instance.currentUser!.uid).child("ProfileImage").child('${'*'}.png').getDownloadURL();
    debugPrint(downloadImageUrl);
  }

}