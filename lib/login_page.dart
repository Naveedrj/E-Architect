import 'dart:async';

import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';
import 'package:a_architectural_app/emailVerified.dart';
import 'package:a_architectural_app/resetPassword.dart';
import 'package:a_architectural_app/signup_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AuthRepository/AuthRepository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userLogin = Get.put(AuthRepository());
  final passwordFocusNode=FocusNode();
  var _isObscured;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isObscured=true;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery
        .of(context)
        .size
        .width;
    double h = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Expanded(
            child: Form(
              key: _formKey,
              child:  Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 50, right: 50, top: 30),
                    width: w,
                    height: h * 0.2,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "img/log.png",
                            ),
                            fit: BoxFit.fitWidth
                        )
                    ),

                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    width: w,
                    height: h * 0.11,
                    child: Column(
                      children: const [
                        Text(
                          'Login!',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.only(left: 5, bottom: 5),
                          child: const Text(
                            'Email:',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ),
                        TextFormField(

                          controller: email,
                          validator: (value) {
                            FirebaseAuth auth = FirebaseAuth.instance;
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
                        const SizedBox(height: 20,),
                        Container(
                          margin: const EdgeInsets.only(left: 5, bottom: 5),
                          child: const Text(
                            'Password:',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ),
                        TextFormField(
                          obscureText: _isObscured,
                          focusNode: passwordFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter Password";
                            }
                            if (value.length < 8) {
                              return "Password Length Must be Greater Then 8";
                            }
                            return null;
                          },

                          controller: password,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter Your Password",
                              prefixIcon: const Icon(Icons.password,
                                color: Colors.blueAccent,),
                              suffixIcon: IconButton(
                                padding: const EdgeInsetsDirectional.only(end: 12),
                                icon: _isObscured? const Icon(Icons.visibility): const Icon(Icons.visibility_off), onPressed: () { setState(() {
                                _isObscured=!_isObscured;
                              }); },
                              )
                          ),
                        ),
                        // const SizedBox(height: 5,),
                        Row(

                          children: [
                            Expanded(child: Container(
                            ),),
                            TextButton(
                              onPressed:(){ Get.to(ResetPassword()
                              );},
                              child: const Text(
                                'Forgot Your Password?',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),)

                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),

                  Container(
                    
                    child: SizedBox(
                      height: 60,
                      width: 300,
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),

                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login please wait......'),behavior: SnackBarBehavior.floating,),);
                            String? value = await userLogin.signIn(
                                email.text.trim(), password.text.trim());
                            if (value == null) {
                              initStates();
                            } else {
                              _showSimpleDialogs();
                            }
                          } else {
                            _showSimpleDialog();
                          }
                        },
                        child: const Text('Login',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,

                          ),),
                      ),
                    ),
                  ),
                  SizedBox(height: w * 0.08,),
                  RichText(text: TextSpan(
                      text: "Don't have an Account? ",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18
                      ),
                      children: [
                        TextSpan(
                            text: " SignUp ",
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(() => const SignUpPage())
                        )
                      ]
                  )
                  ),

                ],
              ),
            ),
          )
        )
    );
  }

  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
            title: const Text('Wrong Email and Password'),
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

  Future<void> _showSimpleDialogs() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
            title: const Text("Wrong Email and Password doesn't Exits"),
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

  @override
  void initStates() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) {
        return const VerifiedEmailPage();
            //return BottomTabs(selectedIndex: 0);
      }), (route) => false);
    });
  }
}
