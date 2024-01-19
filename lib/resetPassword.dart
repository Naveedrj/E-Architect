import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';

class ResetPassword extends StatelessWidget {
final email=TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 250,
                          height: 200,
                          child: Image.asset("img/log.png"),
                        ),
                      ),
                      Center(
                        child: Text("Forgot your Password?",style: TextStyle(fontSize: 25,color: Colors.blueAccent,fontWeight: FontWeight.bold),),

                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("That's okay,it happens! Enter your Email, click\nthe Reset Button to Reset your Password, Reset link will be sent to your email, check your email!",style: TextStyle(color: Colors.grey[600],),),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(

                        controller: email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter your Email";
                          }
                          if (!RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(value)) {
                            return "Please Enter valid Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "Enter Your Email",
                          prefixIcon: const Icon(Icons.email,
                            color: Colors.blueAccent,),


                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(

                        child: SizedBox(
                          height: 60,
                          width: 350,

                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                )

                            ),

                            onPressed:(){
                              if (_formKey.currentState!.validate()) {
                                sendResetPassword();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Reset link has been sent to your email...')),
                                );
                                Timer(Duration(seconds: 4), () {
                                  Navigator.pushAndRemoveUntil(
                                      context, MaterialPageRoute(builder: (BuildContext context) {
                                    return LoginPage();
                                  }), (route) => false);
                                });
                              } else {
                                _showSimpleDialog(context);
                              }

                            },

                            child: const Text('Reset Password',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,

                              ),

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }

  sendResetPassword() {

    FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.toString());
  }
Future<void> _showSimpleDialog(BuildContext context) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog( // <-- SEE HERE
          title: const Text('Invalid Email! Try again'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(child: const Text('close', style: TextStyle(

              ),)),
            ),

          ],
        );
      });
}
}
