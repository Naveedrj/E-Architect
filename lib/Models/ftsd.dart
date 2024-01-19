import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';
import 'package:a_architectural_app/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:a_architectural_app/loading.dart';

import '../membership.dart';





Future<Uint8List> query(Map<String, dynamic> payload, String modelType) async {
  if(modelType=="FTSD-200/200"){
    final apiUrl = "https://api-inference.huggingface.co/models/NaveedRajput/floorplan200-200";
    final headers = {"Authorization": "Bearer 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"};
    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: json.encode(payload));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to query API');
    }
  } else if(modelType=="FTSD-600/200") {
    final apiUrl = "https://api-inference.huggingface.co/models/usman0007/sd-600-200-1";
    final headers = {"Authorization": "Bearer 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"};
    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: json.encode(payload));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to query API');
    }

  } else {
    final apiUrl = "https://api-inference.huggingface.co/models/usman0007/sd-1200-200";
    final headers = {"Authorization": "Bearer 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"};
    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: json.encode(payload));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to query API');
    }
  }

}


class ftsd extends StatefulWidget {
  var length;
  var width;
  var bedrooms;
  var washrooms;
  var dining;
  var living;
  int geragV=0;
  int lawnV=0;
  int stairV=0;
  String modelType="FTSD-200/200";
  int data=0;
  ftsd(length,width,bedrooms,washrooms,dining,living,int geragV, int lawnV, int stairV, String modelType, int data){
    this.length=length;
    this.width=width;
    this.bedrooms=bedrooms;
    this.washrooms=washrooms;
    this.geragV=geragV;
    this.lawnV=lawnV;
    this.stairV=stairV;
    this.dining=dining;
    this.living=living;
    this.modelType=modelType;
    this.data=data;

  }
  @override
  _ftsdState createState() => _ftsdState(length,width,bedrooms,washrooms,dining,living,geragV,lawnV,stairV,modelType, data);

}

class _ftsdState extends State<ftsd> {
  var length;
  var width;
  var bedrooms;
  var washrooms;
  var dining;
  var living;
  int geragV=0;
  int lawnV=0;
  int stairV=0;
  String modelType="FTSD-200/200";
  int data=0;
  _ftsdState(length,width,bedrooms,washrooms,dining,living,geragV, lawnV,stairV,modelType, data){
    this.length=length;
    this.width=width;
    this.bedrooms=bedrooms;
    this.washrooms=washrooms;
    this.geragV=geragV;
    this.lawnV=lawnV;
    this.stairV=stairV;
    this.dining=dining;
    this.living=living;
    this.modelType=modelType;
    this.data=data;

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
  int leng=0;
  String tDis="Generating Design Please Wait...";
  String apiUrl="";
  String headers="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateFloorPlan();
    setState(() {
      Loading();
      tDis="Generating Designs Please Wait...";
      imageVisible=true;
      isVisible=false;
      leng=int.parse(length.text.toString());
    });



  }
  showDiaLoag(){
    Loading.showLoading("Loading..");
  }
  hideDialog(){
    Loading.hideDialog();
  }
  _showSimpleDialogs() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog( // <-- SEE HERE
            title: Text("No credit!"),
            content: Text("Please Upgrade your plan"),
            actions: <Widget>[
              TextButton(onPressed:() {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }, child: Center(child: const Text('close',style: TextStyle(

              ),)),),
              TextButton(onPressed:() {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return MemberShip();
                }));
              }, child: Center(child: const Text('Upgrade plan',style: TextStyle(
                  fontWeight: FontWeight.bold
              ),)),)
            ],
          );
        });
  }

  Future<void> generateFloorPlan() async {

    if(data<1){
      _showSimpleDialogs();
    } else {
      setState(() {
        _isLoading = true;
      });
      final payload = {
        "inputs": "Floorplan of length ${leng.toString()} feet and width ${int
            .parse(width.text.trim())}  feet with ${int.parse(
            bedrooms.text.trim())}  bedroom ${int.parse(
            washrooms.text.trim())}  toilets ${int.parse(
            dining.text.trim())}  dining room ${int.parse(living.text
            .trim())}  living room 1 kitchen $geragV garage $lawnV lawn $stairV stairs",
      };

      try {
        final imageBytes = await query(payload, modelType);
        setState(() {
          _isLoading = false;
        });
        setState(() {
          data = data - 1;
        });
        updateImagesByEmail(data.toString());

        setState(() {
          _imageData = imageBytes;
          count = 1;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;

          tDis = "System is not responding, please try Again later ";
        });

        _showErrorDialog('Failed to generate image');
      }
    }
  }
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;
    if(_isLoading==false){
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
                      /*Column(
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
                    ),*/
                      SizedBox(height: 30,),

                      Visibility(
                        visible: imageVisible,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Container(
                          width: w*0.95,
                          height: h*0.7,
                          child: count==0? Text(tDis): _imageData!=null? GestureDetector(
                            onScaleStart: (details) {
                              setState(() {
                                _previousScale = _scale;
                              });
                            },
                            onScaleUpdate: (details) {
                              setState(() {
                                _scale = _previousScale * details.scale;
                              });
                            },
                            child: Transform.scale(
                              scale: _scale,
                              child: Image.memory(_imageData,height: 300.0, // Adjust the initial height as needed
                                width: 300.0,), // Replace with your image path
                            ),
                          ): Text(tDis),
                          /*child: count==0? Text(tDis): _imageData!=null? Image.memory(_imageData): Text(tDis),*/

                          /*child: count==0? Text(tDis): _imageData!=null? CachedNetworkImage(
                          imageUrl: 'data:image/;base64,${base64Encode(_imageData)}',
                          fit: BoxFit.cover,
                          width: 200,
                          height: 150,
                          alignment: Alignment.center,
                        )
                              : Text(tDis),*/
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
                                    setState(() {
                                      leng=leng+1;
                                    });
                                    /* _showLoadingDialog("Loading..");*/
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
    } else{
      return Scaffold(
        appBar: AppBar(title: const Text('Generated Designs'),centerTitle: true,backgroundColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.white,
        body: Dialog(
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
                    Text("Loading...")
                  ],
                ),
              ),
            )
        ),
      );
     /* return Dialog(
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
                  Text("Loading...")
                ],
              ),
            ),
          )
      );*/
    }

  }


  void _showErrorDialog(String message) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error! Server Not Responding'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('go back'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  savePlan(){

    int len=0;
    Reference reference1;
    final id = new DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference=FirebaseStorage.instance.ref(FirebaseAuth.instance.currentUser!.uid).child("GeneratedImage").child(id);
    len=int.parse(length.text.toString());
    reference.putData(_imageData,SettableMetadata(contentType: 'image/jpeg'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving Design Please Wait...'),behavior: SnackBarBehavior.floating,),
    );
    if(len>=25 && len<=30){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("25").child(id);
    } else if(len>=31 && len<=35){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("31").child(id);
    } else if(len>=36 && len<=40){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("36").child(id);
    } else if(len>=41 && len<=45){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("41").child(id);
    } else if(len>=46 && len<=50){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("46").child(id);
    } else if(len>=51 && len<=55){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("51").child(id);
    } else if(len>=56 && len<=60){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("56").child(id);
    } else if(len>=61 && len<=65){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("61").child(id);
    } else if(len>=66 && len<=70){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("66").child(id);
    } else if(len>=71 && len<=75){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("71").child(id);
    } else if(len>=76 && len<=80){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("76").child(id);
    } else if(len>=81 && len<=85){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("81").child(id);
    } else if(len>=86 && len<=90){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("86").child(id);
    } else if(len>=91 && len<=95){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("91").child(id);
    } else if(len>=96 && len<=99){
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("96").child(id);
    } else {
      reference1=FirebaseStorage.instance.ref().child("AllImages").child("100").child(id);
    }


    reference1.putData(_imageData,SettableMetadata(contentType: 'image/jpeg'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please Wait...'),behavior: SnackBarBehavior.floating,),
    );
    reference1.putData(_imageData,SettableMetadata(contentType: 'image/jpeg'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Design Saved'),behavior: SnackBarBehavior.floating,),
    );

  }
  Future<void> updateImagesByEmail(String newImageUrl) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the 'Images' field with the new URL
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(documentId)
            .update({'Images': newImageUrl.toString()});

        print('Document updated with new Images URL: $newImageUrl');
      } else {
        print('Document not found.');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

}