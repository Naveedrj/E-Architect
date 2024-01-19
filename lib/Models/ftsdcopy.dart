import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';
import 'package:a_architectural_app/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;


final apiUrl = "https://api-inference.huggingface.co/models/NaveedRajput/floorplan200-200";
final headers = {"Authorization": "Bearer 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"};

Future<Uint8List> query(Map<String, dynamic> payload) async {
  final response = await http.post(Uri.parse(apiUrl), headers: headers, body: json.encode(payload));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to query API');
  }
}


class FTSDCopy extends StatefulWidget {
  var length;
  var width;
  var bedrooms;
  var washrooms;
  int geragV=0;
  int lawnV=0;
  int stairV=0;
  FTSDCopy(length,width,bedrooms,washrooms,int geragV, int lawnV, int stairV){
    this.length=length;
    this.width=width;
    this.bedrooms=bedrooms;
    this.washrooms=washrooms;
    this.geragV=geragV;
    this.lawnV=lawnV;
    this.stairV=stairV;

  }
  @override
  _FTSDCopyState createState() => _FTSDCopyState(length,width,bedrooms,washrooms,geragV,lawnV,stairV);

}

class _FTSDCopyState extends State<FTSDCopy> {
  var length;
  var width;
  var bedrooms;
  var washrooms;
  int geragV=0;
  int lawnV=0;
  int stairV=0;

  _FTSDCopyState(length,width,bedrooms,washrooms,int geragV, int lawnV,int stairV){
    this.length=length;
    this.width=width;
    this.bedrooms=bedrooms;
    this.washrooms=washrooms;
    this.geragV=geragV;
    this.lawnV=lawnV;
    this.stairV=stairV;

  }
  // final _textController = TextEditingController();
  var gerage=TextEditingController();
  late Uint8List _imageData = Uint8List(0);
  final GlobalKey<FormState> _formKey=  GlobalKey<FormState>();
  bool _isLoading = false; // Add this line
  bool gerag=false;
  bool lawn=false;
  int count=0;
  bool stair=false;
  bool isVisible=true;
  bool imageVisible=false;

  int counter=0;
  String tDis="Generating Design Please Wait...";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateFloorPlan();
    setState(() {
      tDis="Generating Designs Please Wait...";
      imageVisible=true;
      isVisible=false;
    });

  }

  Future<void> generateFloorPlan() async {

    setState(() {
      _isLoading = true;
    });
    final payload = {
      "inputs": "2d floorplan of length $length feet and width $width feet with $bedrooms bedroom $washrooms toilets 1 dining room 1 living room 1 kitchen $geragV garage $lawnV lawn $stairV stairs",
    };

    try {
      final imageBytes = await query(payload);
      setState(() {
        _isLoading = false;
      });
      setState(() {
        _imageData=imageBytes;
        count=1;
      });
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('Failed to generate image');
    }
  }


  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;

    String tDis="Generating Design Please Wait...";
    return WillPopScope(child: SafeArea(
      child: Scaffold(
          backgroundColor:Colors.white,
          appBar: AppBar(title: const Text('Generated Designs'),centerTitle: true,backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            child: Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20,right: 20),
                            width: w,
                            child:Visibility(
                              visible: isVisible,
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                ],
                              ),
                            ),
                          ),)
                      ],
                    ),
                    SizedBox(height: 30,),

                    Visibility(
                      visible: imageVisible,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Container(
                        width: w*0.95,
                        height: h*0.4,
                        child: count==0? Text(tDis): _imageData!=null? Image.memory(_imageData): Text(tDis),
                      ),),

                    SizedBox(height: 20,),

                    Visibility(visible: imageVisible,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              width: 160,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,

                                ),
                                onPressed: savePlan,
                                child: _isLoading
                                    ? const SizedBox(height:30, width:30,child: CircularProgressIndicator(color: Colors.redAccent))
                                    : const Text('Save Design'),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              width: 160,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                ),
                                onPressed:/* _convertTextToImage*/(){

                                  generateFloorPlan();
                                },
                                child: _isLoading
                                    ? const SizedBox(height:30, width:30,child: CircularProgressIndicator(color: Colors.redAccent))
                                    : const Text('Regenerate Design'),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          )
      ),
    ), onWillPop: () async{
      Navigator.pop(context);
      return true;
    });
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  savePlan(){
    Reference reference1;
    final id = new DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference=FirebaseStorage.instance.ref(FirebaseAuth.instance.currentUser!.uid).child("GeneratedImage").child(id);
    length=int.parse(length.text.trim());
    if(length>=25 && length<=30){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("25").child(id);
    } else if(length>=31 && length<=35){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("31").child(id);
    } else if(length>=36 && length<=40){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("36").child(id);
    } else if(length>=41 && length<=45){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("41").child(id);
    } else if(length>=46 && length<=50){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("46").child(id);
    } else if(length>=51 && length<=55){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("51").child(id);
    } else if(length>=56 && length<=60){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("56").child(id);
    } else if(length>=61 && length<=65){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("61").child(id);
    } else if(length>=66 && length<=70){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("66").child(id);
    } else if(length>=71 && length<=75){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("71").child(id);
    } else if(length>=76 && length<=80){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("76").child(id);
    } else if(length>=81 && length<=85){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("81").child(id);
    } else if(length>=86 && length<=90){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("86").child(id);
    } else if(length>=91 && length<=95){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("91").child(id);
    } else if(length>=96 && length<=99){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("96").child(id);
    } else {
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("100").child(id);
    }
    reference.putData(_imageData,SettableMetadata(contentType: 'image/jpeg'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving Design Please Wait...')),
    );

    reference1.putData(_imageData,SettableMetadata(contentType: 'image/jpeg'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please Wait...')),
    );

  }
}