import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';
import 'package:a_architectural_app/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../membership.dart';


class RSD extends StatefulWidget {
  var length;
  var width;
  var bedrooms;
  var washrooms;
  var dining;
  var living;
  int geragV=0;
  int lawnV=0;
  int stairV=0;
  int data=0;
  RSD(length,width,bedrooms,washrooms,dining,living, int geragV, int lawnV, int stairV, int data){
    this.length=length;
    this.width=width;
    this.bedrooms=bedrooms;
    this.washrooms=washrooms;
    this.geragV=geragV;
    this.lawnV=lawnV;
    this.stairV=stairV;
    this.dining=dining;
    this.living=living;
    this.data=data;

  }
  @override
  _RSDState createState() => _RSDState(length,width,bedrooms,washrooms,dining,living,geragV,lawnV,stairV,data);

}

class _RSDState extends State<RSD> {
  var length;
  var width;
  var bedrooms;
  var washrooms;
  var dining;
  var living;
  int geragV=0;
  int lawnV=0;
  int stairV=0;
  int data=0;
  _RSDState(length,width,bedrooms,washrooms,dining,living, int geragV, int lawnV,int stairV,int data){
    this.length=length;
    this.width=width;
    this.bedrooms=bedrooms;
    this.washrooms=washrooms;
    this.geragV=geragV;
    this.lawnV=lawnV;
    this.stairV=stairV;
    this.dining=dining;
    this.living=living;
    this.data=data;
    /*this._convertTextToImage();*/
  }
  // final _textController = TextEditingController();

  var _textController='2d architectural plan for square land with,2 bedrooms,2 washrooms,1 kitchen';

  var gerage=TextEditingController();
  late Uint8List _imageData = Uint8List(0);
  final GlobalKey<FormState> _formKey=  GlobalKey<FormState>();
  bool _isLoading = false; // Add this line
  bool gerag=false;
  bool lawn=false;

  int count=0;
  bool isVisible=true;
  bool imageVisible=false;
  String tDis="Generating Design Please Wait...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _convertTextToImage();
    setState(() {
      tDis="Generating Designs Please Wait...";
      imageVisible=true;
      isVisible=false;
    });

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
  void _convertTextToImage() async {
    setState(() {
      _isLoading = true;
    });
    if(data<1){
      _showSimpleDialogs();
    } else {
      const baseUrl = 'https://api.stability.ai';
      _textController =
      "floorplan of length ${int.parse(length.text.trim())} feet and width ${int
          .parse(width.text.trim())}  feet with ${int.parse(
          bedrooms.text.trim())}  bedroom ${int.parse(
          washrooms.text.trim())}  toilets ${int.parse(
          dining.text.trim())}  dining room ${int.parse(living.text
          .trim())}  living room 1 kitchen $geragV garage $lawnV lawn $stairV stairs";
      //_textController="2d architectural plan for ${int.parse(length.text.trim())} length and ${int.parse(width.text.trim())} width with ${int.parse(bedrooms.text.trim())} bedrooms,${int.parse(washrooms.text.trim())} washroom,1 kitchen,${geragV} gerage,${lawnV} lawn";
      debugPrint(_textController);
      final url = Uri.parse(
          '$baseUrl/v1alpha/generation/stable-diffusion-512-v2-0/text-to-image');

      // Make the HTTP POST request to the Stability Platform API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'sk-Mc1OWiscf1M5r5QSmRrAXjcbh6kt52br2HCMWEbgqilZDMsB',
          'Accept': 'image/png',
        },
        body: jsonEncode({
          'cfg_scale': 7,
          'clip_guidance_preset': 'FAST_BLUE',
          'height': 512,
          'width': 512,
          'samples': 1,
          'steps': 50,
          'text_prompts': [
            {
              'text': _textController ?? '',
              'weight': 2,
            }
          ],
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode != 200) {
        _showErrorDialog('Failed to generate image');
      }
      else {
        try {
          _imageData = (response.bodyBytes);
          count = 1;
          setState(() {
            data = data - 1;
          });
          updateImagesByEmail(data.toString());
        } on Exception
        catch (e) {
          _showErrorDialog('Failed to generate image');
        }
      }
    }
  }
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;

    if(_isLoading==false) {
      return WillPopScope(child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(title: const Text('Generated Designs'),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
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
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20),
                              width: w,
                              child: Visibility(
                                visible: isVisible,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Center(
                                        child: SizedBox(
                                          height: 60,
                                          width: 300,
                                          child: ElevatedButton( style: ElevatedButton.styleFrom(
                                              primary: Colors.blueAccent,
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)
                                              )
                                          ),onPressed: (){
                                            _convertTextToImage();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Generating Design Please Wait...')),
                                            );
                                            setState(() {
                                              tDis="Generating Designs Please Wait...";
                                              imageVisible=true;
                                              isVisible=false;
                                            });
                                            // Get.to(()=>Generate(length.text.trim(),width.text.trim(),bedrooms.text.trim(),washrooms.text.trim()));

                                          }, child: _isLoading
                                              ? const SizedBox(height:30, width:30,child: CircularProgressIndicator(color: Colors.redAccent))
                                              : const Text('Generate Design')),
                                        )
                                    ),
                                  ),*/

                                  ],
                                ),
                              ),
                            ),)
                        ],
                      ),
                      /*TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter your input',
                  fillColor: Colors.white,
                  filled: true,
                  // contentPadding: const EdgeInsets.all(16),
                  // labelStyle: TextStyle(color: Colors.red),
                ),
              ),*/
                      SizedBox(height: 30,),
                      /* Container(
                      child: FutureBuilder(
                        future: _convertTextToImage(),
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.done){
                            return
                              Image.asset("img/25x45 plan with 2 bedrooms 2 washrooms 1 living 1 dining 1 kitchen.jpeg");
                          } else {
                            return Text("Please Wait....");
                          }
                        },
                      ),
                    ),*/
                      Visibility(
                        visible: imageVisible,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Container(
                          width: w * 0.95,
                          height: h * 0.7,
                          child: count == 0 ? Text(tDis) : _imageData != null
                              ? GestureDetector(
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
                          )
                              : Text(tDis),
                        ),),
                      //if(_imageData != null ) Image.memory(_imageData),
                      SizedBox(height: 20,),
                      /* Container(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,

                        ),
                        onPressed: _convertTextToImage,
                        child: _isLoading
                            ? const SizedBox(height:30, width:30,child: CircularProgressIndicator(color: Colors.redAccent))
                            : const Text('click to generate Designs'),
                      ),
                    ),*/
                      Visibility(visible: imageVisible,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Row(
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
                                      ? const SizedBox(height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                          color: Colors.redAccent))
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
                                  onPressed: _convertTextToImage,
                                  child: _isLoading
                                      ? const SizedBox(height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                          color: Colors.redAccent))
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
      ), onWillPop: () async {
        Navigator.pop(context);
        return true;
      });
    } else {
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
              child: const Text('Ok'),
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
      const SnackBar(content: Text('Saving Design Please Wait...'),behavior: SnackBarBehavior.floating,),
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