import 'package:a_architectural_app/fulView.dart';
import 'package:a_architectural_app/profile.dart';
import 'package:a_architectural_app/profileContollor/profileControllor.dart';
import 'package:a_architectural_app/user_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'drawer/drawer_menu.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  bool isLoading=false;
  int credit=0;

  List<String> imageUrls = [];
  @override
  void initState() {
    super.initState();
    fetchImages();
  }
  void fetchImages() async {
    setState(() {
      isLoading=true;
    });
    // Create a reference to your Firebase Storage bucket
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child("AllImages").child("25");

    // List the contents of the bucket
    final ListResult result = await storageRef.listAll();

    // Get the first 5 image URLs
    for (var item in result.items.take(10)) {
      final imageUrl = await item.getDownloadURL();
      setState(() {
        imageUrls.add(imageUrl);
        isLoading=false;
      });
    }
  }

  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  Widget build(BuildContext context) {
    final controller=Get.put(ProfileControllor());
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;
    return WillPopScope(child: Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Row(
          children: [
            Text('Home'),
            SizedBox(width: w*0.3,),
            Text('Credit: '),

            Expanded(child: FutureBuilder(
                future: controller.getUserData(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            if(snapshot.hasData){
              UserModel userData=snapshot.data as UserModel;
              return  Row(
                children: [

                  Text(userData.images)
                ],
              );
            } else if(snapshot.hasError){
              return  Center(child: Text(snapshot.error.toString()),);
            } else {
              return Center(child: Text("Somthing went Wrong!"),);
            }
          } else {
            return Center(child: CircularProgressIndicator(color: Colors.white,),);
          }
        },
      ),)
          ],
        ),
        backgroundColor: Colors.blueAccent,

      ),

      body: SingleChildScrollView(
        child: Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white70, Colors.grey], // Define your gradient colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
           //
            // color: Colors.blueGrey[50],
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                Column(

                  children: [
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: Offset(0, 3), // Offset
                                ),
                              ],
                            gradient: LinearGradient(
                              colors: [Colors.blueAccent, Colors.lightBlueAccent], // Define your gradient colors
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'New Design',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                fontFamily: "Times New Roman"
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),


                    Container(
                      width: w,
                      height: h*0.4,
                      child: isLoading==false? CarouselSlider.builder(
                        itemCount: imageUrls.length,
                        itemBuilder: (BuildContext context, int index, int realIndex) {
                          return Container(padding: EdgeInsets.all(10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Image.network(imageUrls[index],fit: BoxFit.fill,)
                                    ],
                                  )));
                        },
                        options: CarouselOptions(
                          height: h*0.4,
                          autoPlay: true,
                          autoPlayCurve: Curves.easeInOut,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          viewportFraction: 0.7 ,
                          // Disable infinite scrolling
                        ),
                      ): Center(child: Container(width:50,height: 50,child: const CircularProgressIndicator(color: Colors.blueAccent,))),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
               /* Container(
                  width: w*0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white70,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Offset
                      ),
                    ]
                  ),
                  child: Column(

                    children: [
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          SizedBox(width: 20,),
                          Center(
                            child: Text(
                              'NEW DESIGNS',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontFamily: "Times New Roman"
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),


                      Container(
                        child: CarouselSlider.builder(
                          itemCount: imageUrls.length,
                          itemBuilder: (BuildContext context, int index, int realIndex) {
                            return Container(padding: EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Image.network(imageUrls[index],fit: BoxFit.fill,)
                                      ],
                                    )));
                              GestureDetector(
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
                                  child: Image.network(imageUrls[index],height: 300,width: 300,), // Replace with your image path
                                ),
                              );
                              Container(
                                color: Colors.white,
                                child: PhotoViewGallery.builder(
                                  itemCount:  imageUrls.length,
                                  builder: (context, index) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider: NetworkImage(imageUrls[index]),
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
                              );
                          },
                          options: CarouselOptions(
                              height: h*0.4,
                              autoPlay: true,
                              autoPlayCurve: Curves.easeInOut,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              viewportFraction: 0.8 ,
                            // Disable infinite scrolling
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),*/

                /*Container(
                  height: h*0.6,
                  width: w,
                  color: Colors.white,
                  child: Container(
                    width: w*0.5,
                    height: h*0.4,
                    padding: EdgeInsets.all(20),
                    child: PhotoViewGallery.builder(
                      itemCount:  imageUrls.length,
                      builder: (context, index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(imageUrls[index]),
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
                ),*/
                /*CarouselSlider(
                    items: [

                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            image: DecorationImage(
                                image: AssetImage('img/2.jpg'),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            image: DecorationImage(
                                image: AssetImage('img/3.png'),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            image: DecorationImage(
                                image: AssetImage('img/4.jpg'),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            image: DecorationImage(
                                image: AssetImage('img/5.png'),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                        height: 300.0,
                        autoPlay: true,
                        autoPlayCurve: Curves.easeInOut,
                        enlargeCenterPage: true,
                        viewportFraction: 0.6
                    )
                ),*/
                SizedBox(height: 20,),
                Container(
                  width: w*0.95,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    //  color: Colors.lightBlueAccent[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white70.withOpacity(0.3), // Shadow color
                          spreadRadius: 5, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset: Offset(0, 3), // Offset
                        ),
                      ],
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.blueGrey], // Define your gradient colors
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          SizedBox(width: 15,),
                          Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.blueAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3), // Shadow color
                                    spreadRadius: 3, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: Offset(0, 3), // Offset
                                  ),
                                ],
                              gradient: LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlueAccent], // Define your gradient colors
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Most Popular',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "Times New Roman"
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            TextButton(onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return FullView(25);
                              }));
                            }, child:  Column(
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        image: DecorationImage(
                                            image: AssetImage('img/2.jpg'),
                                            fit: BoxFit.cover
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3), // Shadow color
                                            spreadRadius: 3, // Spread radius
                                            blurRadius: 5, // Blur radius
                                            offset: Offset(0, 3), // Offset
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Center(child: Text("25x25",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white70),),),
                              ],
                            ),),
                            TextButton(onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return FullView(51);
                              }));
                            }, child:  Column(
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        image: DecorationImage(
                                            image: AssetImage('img/2.jpg'),
                                            fit: BoxFit.cover
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3), // Shadow color
                                            spreadRadius: 3, // Spread radius
                                            blurRadius: 5, // Blur radius
                                            offset: Offset(0, 3), // Offset
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Center(child: Text("50x50",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white70),),),
                              ],
                            ),),
                            TextButton(onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return FullView(76);
                              }));
                            }, child:  Column(
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        image: DecorationImage(
                                            image: AssetImage('img/2.jpg'),
                                            fit: BoxFit.cover
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3), // Shadow color
                                            spreadRadius: 3, // Spread radius
                                            blurRadius: 5, // Blur radius
                                            offset: Offset(0, 3), // Offset
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Center(child: Text("75x75",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white70),),),
                              ],
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Center(
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            TextButton(onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return FullView(30);
                              }));
                            }, child:  Column(
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        image: DecorationImage(
                                            image: AssetImage('img/2.jpg'),
                                            fit: BoxFit.cover
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3), // Shadow color
                                            spreadRadius: 3, // Spread radius
                                            blurRadius: 5, // Blur radius
                                            offset: Offset(0, 3), // Offset
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Center(child: Text("30x30",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white70),),),
                              ],
                            ),),
                            TextButton(onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return FullView(40);
                              }));
                            }, child:  Column(
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        image: DecorationImage(
                                            image: AssetImage('img/2.jpg'),
                                            fit: BoxFit.cover
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3), // Shadow color
                                            spreadRadius: 3, // Spread radius
                                            blurRadius: 5, // Blur radius
                                            offset: Offset(0, 3), // Offset
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Center(child: Text("40x40",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white70),),),
                              ],
                            ),),
                            TextButton(onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return FullView(60);
                              }));
                            }, child:  Column(
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        image: DecorationImage(
                                            image: AssetImage('img/2.jpg'),
                                            fit: BoxFit.cover
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3), // Shadow color
                                            spreadRadius: 3, // Spread radius
                                            blurRadius: 5, // Blur radius
                                            offset: Offset(0, 3), // Offset
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Center(child: Text("60x60",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white70),),),
                              ],
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    ), onWillPop: () async {
      return await showDialog(context: context, builder: (context)=> AlertDialog(
        title: Text("Do you want to close the app?"),
        actions: <Widget>[
          ElevatedButton(
              onPressed: ()=>Navigator.pop(context,false),
              child: Text("No")),
          ElevatedButton(onPressed: ()=>Navigator.pop(context,true), child: Text("Yes")),
        ],
      ));
    });
  }
}

