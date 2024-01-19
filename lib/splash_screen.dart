import 'dart:async';
import 'package:a_architectural_app/AuthRepository/AuthRepository.dart';
import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';
import 'package:a_architectural_app/emailVerified.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Models/ftsd.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  final AuthRepo=Get.put(AuthRepository());
  Future<void> generateFloorPlan(String modelType) async {

      final payload = {
        "inputs": "Floorplan of length 25 feet and width 25  feet with 25  bedroom 1  toilets 1  dining room 1  living room 1 kitchen 1 garage 1 lawn 1 stairs",
      };

      try {
        final imageBytes = await query(payload, modelType);
        print("ok");
      } catch (e) {
        print('Error: $e');


      }
  }
  @override
  void initState(){
    super.initState();
    generateFloorPlan("FTSD-600/200");
    generateFloorPlan( "FTSD-200/200");
    generateFloorPlan("FTSD-1200/400");

    Timer(Duration(seconds: 10),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context , snapshot){
            if(snapshot.hasData){
             return VerifiedEmailPage();
              // return BottomTabs(selectedIndex: 0);
            } else{
              return const LoginPage();
            }
          }

      ),));
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>homePage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(
              "img/log.png",
            ),
              height: 150,
              //width: 150,
              //fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 20,),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            )

          ],
        ),
      ),
    );
  }
}
