import 'dart:convert';
import 'dart:typed_data';

import 'package:a_architectural_app/profileContollor/profileControllor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'bottomTabs/bottomTabs.dart';
import 'drawer/drawer_menu.dart';
class FullView extends StatefulWidget {
  var length;
  FullView(length){
    this.length=length;
  }


  @override
  State<FullView> createState() => _FullViewState(length);
}

class _FullViewState extends State<FullView> {
  var length;
  _FullViewState(length){
    this.length=length;
  }
  FirebaseStorage storage = FirebaseStorage.instance;
  final controller=Get.put(ProfileControllor());
  late  Future<List<String>> image;
  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    return image;
  }
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];
    if(length>=25 && length<=30){
    length=25;
    } else if(length>=31 && length<=35){
      length=31;
    } else if(length>=36 && length<=40){
      length=36;
    } else if(length>=41 && length<=45){
      length=41;
    } else if(length>=46 && length<=50){
      length=46;
    } else if(length>=51 && length<=55){
      length=51;
    } else if(length>=56 && length<=60){
      length=56;
    } else if(length>=61 && length<=65){
      length=61;
    } else if(length>=66 && length<=70){
      length=66;
    } else if(length>=71 && length<=75){
      length=71;
    } else if(length>=76 && length<=80){
      length=76;
    } else if(length>=81 && length<=85){
      length=81;
    } else if(length>=86 && length<=90){
      length=86;
    } else if(length>=91 && length<=95){
      length=91;
    } else if(length>=96 && length<=99){
      length=96;
    } else {
      length=100;
    }
    final ListResult result = await storage.ref().child("AllImages").child(length.toString()).list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();

      files.add({
        "url": fileUrl,
        "path": file.fullPath,
      });
    });

    return files;
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;
    //  image= controller.getFirebaseImageFolder() as Future<List<String>>;
    return WillPopScope(child: Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text('Designs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {

                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                        snapshot.data![index];
                        try{

                          return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        width: w*0.9,
                                        height: h*0.6,
                                        child: Container(
                                          child: PhotoViewGallery.builder(
                                            itemCount:  snapshot.data?.length ?? 0,
                                            builder: (context, index) {
                                              return PhotoViewGalleryPageOptions(
                                                imageProvider: NetworkImage(image['url']),
                                                minScale: PhotoViewComputedScale.contained,
                                                maxScale: PhotoViewComputedScale.covered * 2,
                                              );
                                            },
                                            scrollPhysics: BouncingScrollPhysics(),
                                            backgroundDecoration: BoxDecoration(
                                              color: Colors.black,
                                            ),
                                            pageController: PageController(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                    ],
                                  )

                                ],
                              )
                          );
                        } catch(e){
                          print("Got exception ${e.toString()}");
                          return Center(
                            child: Text("No image Found"),
                          );
                        }

                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
            ),


          ),
        ],
      ),
      /*body: FutureBuilder(
          future: controller.getFirebaseImageFolder(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              if(snapshot.hasData){
                return ListView.builder(itemBuilder: (BuildContext ctx,int index){
                  return Image.network(image as String);
                } );
              } else {
              return const Center(child: Text("Somthing went Wrong!"),);
              }

            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          },
        ),*/
      /* body: ListView.builder(itemBuilder: (BuildContext ctx,int index){
          return Image.network(image[index]);
        },itemCount: image.length, )*/
    ), onWillPop: () async {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) {
        return BottomTabs(selectedIndex: 0);
      }), (route) => false);
      return true;
    });
  }
}
