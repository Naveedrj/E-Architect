import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'bottomTabs/bottomTabs.dart';

class VerifiedEmailPage extends StatefulWidget {
  const VerifiedEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifiedEmailPage> createState() => _VerifiedEmailPageState();
}

class _VerifiedEmailPageState extends State<VerifiedEmailPage> {
  bool isEmailVerified=false;
  bool canResentEmail=false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    isEmailVerified=FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();
      timer= Timer.periodic(Duration(seconds: 3),(_)=> CheckEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  Future CheckEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified=FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified){
      timer?.cancel();
    }
  }
  Future sendVerificationEmail() async {
    try{
      final user=FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(()=> canResentEmail=false);
      await Future.delayed(Duration(seconds: 5));
      setState(()=> canResentEmail=true);
    } catch(e){
      _showSimpleDialog(e.toString());
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

  @override
  Widget build(BuildContext context) =>isEmailVerified  ? BottomTabs(selectedIndex: 0) :  Scaffold(
      appBar: AppBar(
      title: Text(
      "verify email"
      ),
      ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("A verification Email Has been Sent to your Email. click the link to verify the email",style: TextStyle(
            fontSize: 15,
          ),
          textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          ElevatedButton.icon(
          style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
          onPressed: canResentEmail? sendVerificationEmail:null,
              icon: Icon(Icons.email,size: 28,), label: Text(
            "Resent Email",
            style: TextStyle(
              fontSize: 22
            ),
          )),
          SizedBox(height: 10,),
          TextButton(onPressed: ()=>FirebaseAuth.instance.signOut(), child: Text("Cancel"))
        ],
      ),
    )
  );


}
