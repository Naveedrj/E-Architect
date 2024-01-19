
import 'dart:async';

import 'package:a_architectural_app/bottomTabs/bottomTabs.dart';
import 'package:a_architectural_app/userRepository/user_repository.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AuthRepository/AuthRepository.dart';
import 'emailVerified.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isBtnClickable=true;
  final GlobalKey<FormState> _formKey=  GlobalKey<FormState>();
  final email=TextEditingController();
  final password=TextEditingController();
  final name_=TextEditingController();
  final phoneNumber_=TextEditingController();
  final userRepo=Get.put(UserRepository());
  final authRepo=Get.put(AuthRepository());
  String phoneNumber="";
  String name="";
  final passwordFocusNode=FocusNode();
  var _isObscured;


  get signUpError => null;
  @override
  void dispose() {
    password.dispose();
    email.dispose();
    name_.dispose();
    phoneNumber_.dispose();

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

    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;
    return Scaffold(
        //resizeToAvoidBottomInset : false,
        body: SingleChildScrollView(
          child: Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30,right: 30,top: 20),
                    width: w,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 50,right: 50,top: 30),
                          width: w*0.55,
                          height: h*0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "img/log.png",
                                  ),
                                  fit: BoxFit.fitWidth
                              )
                          ),

                        ),
                        SizedBox(height: 20,),
                        const Text(
                          'Sign Up!',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                  Container(
                    margin: const EdgeInsets.only(left: 20,right: 20 ,top: 5),
                    width: w,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        TextFormField(
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter your name";
                            }
                            return null;
                          },
                          controller: name_,
                          keyboardType: TextInputType.text,
                          //  controller: name,
                          decoration: InputDecoration(

                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter Your Full Name",
                              prefixIcon: Icon(Icons.perm_identity,color: Colors.blueAccent,)
                          ),
                          onSaved: (na){
                            name=(na) as String;
                          },

                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: phoneNumber_,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter your Phone Number";
                            }
                            String phone=value;
                            if(value.length!=11){
                              return "Please Enter valid Phone Number";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(

                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter Your Phone Number",
                              prefixIcon: Icon(Icons.phone,color: Colors.blueAccent,)
                          ),
                          onSaved: (value){
                            phoneNumber=value as String;
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          validator: (value){
                            FirebaseAuth auth= FirebaseAuth.instance;
                            if(value==null || value.isEmpty){
                              return "please enter your Email";
                            }
                            if(!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value)){
                              return "Please Enter valid Email";
                            }

                            // Future<bool> varify=emailFetch(value) as  Future<bool>;
                            // if(varify==true){
                            //   return "Email Already in Use";
                            // }
                            return null;
                          },
                          controller: email,
                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(

                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter Your Email",
                              prefixIcon: Icon(Icons.email,color: Colors.blueAccent,)
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          obscureText: _isObscured,
                          focusNode: passwordFocusNode,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "please enter Password";
                            }
                            if(value.length<8){
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
                              prefixIcon: Icon(Icons.password_outlined,color: Colors.blueAccent,),
                              suffixIcon: IconButton(
                                padding: const EdgeInsetsDirectional.only(end: 12),
                                icon: _isObscured? const Icon(Icons.visibility): const Icon(Icons.visibility_off), onPressed: () { setState(() {
                                _isObscured=!_isObscured;
                              }); },
                              )
                          ),
                        ),


                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
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
                            )

                        ),

                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data'),behavior: SnackBarBehavior.floating,),
                            );
                            /* try{
                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.toString(), password: password.text.trim());
                            recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const homePage());

                          } on UserCredential catch(e){

                          }*/
                            String? value=await authRepo.signUp(name_.text.trim(), phoneNumber_.text.trim(), email.text.trim(), password.text.trim(),"3");

                            if(value==null){

                              Timer(const Duration(seconds: 3), () { Navigator.pushAndRemoveUntil(
                                  context, MaterialPageRoute(builder: (BuildContext context) {
                               return const VerifiedEmailPage();
                                    // return BottomTabs(selectedIndex: 0);
                              }), (route) => false);
                              });
                            } else {
                              _showSimpleDialog(value);
                            }
                            /*try {
                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email.text.toString(),
                                password: password.text.trim()
                            );
                            final user=UserModel(fullName: name_.text.trim(), phoneNumber: phoneNumber_.text.trim(), email: email.text.trim(), password: password.text.trim());
                            await userRepo.createUser(user);
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                            );
                            Get.to(() => BottomTabs(selectedIndex: 0));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              //print('The account already exists for that email.');
                              _showSimpleDialog();
                            }
                          } catch (e) {
                            print(e);
                          }
*/



                          }


                        },

                        child: const Text('SignUp',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,

                          ),

                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: w*0.08,),
                  RichText(text: TextSpan(
                      text: "have an account? ",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18
                      ),
                      children: [
                        TextSpan(
                            text: " Login ",
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            recognizer: TapGestureRecognizer()..onTap=()=>Get.back()
                        )
                      ]
                  )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  Future<bool> emailFetch(String e) async {
    try{
      final list=await FirebaseAuth.instance.fetchSignInMethodsForEmail(e);
      if(list.isNotEmpty){
        return true;
      } else{
        return false;
      }
    } catch(error){
      return true;
    }
  }
  Future<void> _showSimpleDialog(String value) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
            title: Text(value),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(child: const Text('close',style: TextStyle(

                ),)),
              ),

            ],
          );
        });
  }
// --- Button Widget --- //

}
