import 'package:a_architectural_app/SearchResult.dart';
import 'package:a_architectural_app/drawer/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'bottomTabs/bottomTabs.dart';
import 'generate.dart';
class SearchDesigns extends StatelessWidget {

  final length=TextEditingController();
  final width=TextEditingController();
  final GlobalKey<FormState> _formKey=  GlobalKey<FormState>();

  @override
  void dispose() {
    length.dispose();
    width.dispose();
    // TODO: implement dispose
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text('Search Designs'),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      Container(
                        margin: const EdgeInsets.only(left: 5,bottom: 5),
                        child: const Text(
                          'Length:',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: length,
                        validator: (value){
                          if(value==null || value.isEmpty ){
                            return "please enter length";
                          }
                          if(int.parse(length.text.trim())<25){
                            return "Please Enter length greater then 25 or equal";
                          }
                          return null;
                        },
                        decoration: InputDecoration(

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            hintText: "Enter width",
                            prefixIcon: const Icon(Icons.area_chart_outlined,color: Colors.blueAccent,)
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        margin: const EdgeInsets.only(left: 5,bottom: 5),
                        child: const Text(
                          'Width:',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: width,
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return "please enter width";
                          }
                          if(int.parse(width.text.trim())<25){
                            return "Please Enter Width greater then 25 or equal";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            hintText: "Enter Width",
                            prefixIcon: const Icon(Icons.area_chart,color: Colors.blueAccent,)
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
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
                                if(_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Loading Please Wait...')),
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                    return SearchResult(int.parse(length.text.trim()));
                                  }));
                                }

                              }, child: Text(
                                'Search',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )),
                            )
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    ), onWillPop: () async {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) {
        return BottomTabs(selectedIndex: 0);
      }), (route) => false);
      return true;
    });

  }
}
