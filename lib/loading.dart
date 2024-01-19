import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Loading{
  static void showLoading(String message) {
    Get.dialog(
      Dialog(
        child: Padding(
          
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 200,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8,),
                Text(message)
              ],
            ),
          ),
        )
      )
    );
  }
  static void hideDialog() {
    bool? open=Get.isDialogOpen;
    if (open.isNull) {

    } else {
      Get.back();
    }
  }
}