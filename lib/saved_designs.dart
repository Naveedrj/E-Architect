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

class SavedDesigns extends StatefulWidget {
  const SavedDesigns({Key? key}) : super(key: key);

  @override
  State<SavedDesigns> createState() => _SavedDesignsState();
}

class _SavedDesignsState extends State<SavedDesigns> {
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

    final ListResult result = await storage.ref(FirebaseAuth.instance.currentUser!.uid).child("GeneratedImage").list();
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
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }
  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;
   //  image= controller.getFirebaseImageFolder() as Future<List<String>>;
    return WillPopScope(child: Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text('Saved Designs'),
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
                                        width: w*0.82,
                                        height: h*0.4,
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
                                       )
                                       /* child: Image(image: NetworkImage(image['url']),),*/
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                          child:IconButton(
                                            onPressed: () => _delete(image['path']),
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          )
                                      )
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

