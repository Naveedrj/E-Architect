import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'bottomTabs/bottomTabs.dart';
import 'drawer/drawer_menu.dart';
class MemberShip extends StatefulWidget {
  const MemberShip({super.key});

  @override
  State<MemberShip> createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  Map<String,dynamic>? paymentIntentData;
  Future<String?> findImagesByEmail() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;

        // Check if the 'Images' field exists in the document data
        if (userData.containsKey('Images')) {
          String imagesUrl = userData['Images'];
          print("gift/"+imagesUrl);// Assuming 'Images' is a String
          return imagesUrl;
        } else {
          print('Images not found in document.');
          return null;
        }
      } else {
        print('Document not found.');
        return null;
      }
    } catch (e) {
      print('Error finding document: $e');
      return null;
    }
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
            .update({'Images': newImageUrl});

        print('Document updated with new Images URL: $newImageUrl');
      } else {
        print('Document not found.');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text('Membership'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*TextButton(onPressed: () async{
              await makePayment();
            }, child: Text("Pay"))*/
            SizedBox(height: 20,),
            Text('Upgrade Plan',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35,fontFamily: "New Times Roman",color: Colors.blue),),
            Padding(
              padding: const EdgeInsets.all(16.0),
              
              child: Container(

                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text("Basic Plan",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,fontStyle: FontStyle.italic,color: Colors.blue),),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Duration:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            SizedBox(width: 100,),
                            Text("unlimited Days",style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Number of Images:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            SizedBox(width: 85,),
                            Text("20",style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Price:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            SizedBox(width: 170,),
                            Text("600PKR",style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                          ],
                        ),
                        SizedBox(height: 20,), Container(

                          child: SizedBox(
                            height: 60,
                            width: 250,

                            child: ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )

                              ),

                              onPressed: () async {
                              await  makePayment("2", "USD");
                              String? data=await findImagesByEmail();
                              if(data==null || int.parse(data)<1){
                                updateImagesByEmail("20");
                              } else {
                                int i=int.parse(data.toString());
                                int j=20+i;
                                String sum=j.toString();
                                updateImagesByEmail((sum).toString());
                              }

                              },

                              child: const Text('Subscribe',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,

                                ),

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: Colors.grey[200],

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text("Medium Plan",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,fontStyle: FontStyle.italic,color: Colors.blue),),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Duration:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            SizedBox(width: 100,),
                            Text("unlimited Days",style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Number of Images:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            SizedBox(width: 85,),
                            Text("100",style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Price:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            SizedBox(width: 170,),
                            Text("3000PKR",style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                          ],
                        ),
                        SizedBox(height: 20,), Container(

                          child: SizedBox(
                            height: 60,
                            width: 250,

                            child: ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )

                              ),

                              onPressed: () async {
                                await  makePayment("10", "USD");
                                String? data=await findImagesByEmail();
                                if(data==null || int.parse(data)<1){
                                  updateImagesByEmail("100");
                                } else {
                                  int i=int.parse(data.toString());
                                  int j=100+i;
                                  String sum=j.toString();
                                  updateImagesByEmail((sum).toString());
                                }
                              },

                              child: const Text('Subscribe',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,

                                ),

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
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

  Future<void> makePayment(String amount,String currency) async {
    try{
      paymentIntentData=await createPymentIntent(amount,currency);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              //googlePay: true,
              customFlow: true,
              style: ThemeMode.dark,
              merchantDisplayName: 'Usman Ahmad'

          ));
      displayPaymentSheet();
    } catch(e){
      print(e.toString());
    }
  }
  displayPaymentSheet() async {
    try{
      await Stripe.instance
          .presentPaymentSheet()
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print('payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("please wait..."),behavior: SnackBarBehavior.floating,));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully"),behavior: SnackBarBehavior.floating,));

        setState(() {
          paymentIntentData = null;
        });
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });

    }  on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  createPymentIntent(String amount,String currency) async {
    Map<String , dynamic> body={
      'amount': calculateAmount(amount),
      'currency': currency,
      'payment_method_types[]':'card'
    };
    var responce= await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51NjMjgCD4XrxtcC2hkzreBTQvKYGraK0McKxNwJmFeARMvISXYUEDi6FIcCu0zkW2HemYQ7R8rApSia4Ffmu1FZ900hfA3s33J',
          'Content-Type': 'application/x-www-form-urlencoded'
        }
    );
    return jsonDecode(responce.body.toString());

  }
  calculateAmount(String amount){
    final price=int.parse(amount) * 300;
    return price.toString();
  }
}

