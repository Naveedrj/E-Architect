import 'package:flutter/material.dart';

import 'bottomTabs/bottomTabs.dart';
import 'drawer/drawer_menu.dart';
class PrivacyPolicy extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              Icon(Icons.privacy_tip),
              Text('Privacy Policy'),
            ],
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Center(child: Text("Privacy Policy for E-Architect",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
              SizedBox(height: 5,),
              Text("Effective Date: 2023-08-28"),
              SizedBox(height: 5,),
              Text("This Privacy Policy describes how Gift University collects, uses, shares, and protects your personal information in connection with the use of the E-Architect mobile application"),
              SizedBox(height: 5,),
              Text("By using the App, you consent to the practices described in this Privacy Policy. If you do not agree to this Privacy Policy, please do not use the App."),
              SizedBox(height: 5,),
              Text("Information We Collect",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              SizedBox(height: 5,),
              Column(
                children: [
                  Row(
                    children: [
                      Text("User-Generated Content:",style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text("When you use the App, you may create and input floor plans and related requirements. This information is stored on your device and is not transmitted to our servers unless you choose to share it."),
                ],
              ),
              SizedBox(height: 5,),
              

              Row(
                children: [
                  Text("How We Use Your Information",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 5,),
              Text("We use the information you provide to generate floor plans and fulfill your requirements within the App.We may use aggregated and anonymized data to analyze and improve the App's performance, features, and user experience."),
              SizedBox(height: 5,),
              Row(
                children: [
                  Text("Sharing Your Information",style: TextStyle(fontWeight: FontWeight.bold),),
                ],

              ),
              SizedBox(height: 5,),
              Text("We may share information with third-party service providers who assist us in providing, maintaining, and improving the App. These service providers are obligated to protect your information and are not allowed to use it for other purposes.We may disclose your information if required by law, regulation, legal process, or government request."),
              SizedBox(height: 5,),
              Row(
                children: [
                  Text("Your Choices",style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 5,),
              Text("* You can request access to the personal information we hold about you."),
              Text("* You can request that any inaccuracies in your personal information be corrected."),
              Text("* You can request the deletion of your personal information."),
              SizedBox(height: 5,),
              Text("To exercise any of these rights, please contact us at abbasusman753@gmail.com. We will respond to your request within a reasonable timeframe."),
              SizedBox(height: 5,),
              Row(
                children: [

                  Text("Data Security",style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 5,),
              Text("We take reasonable measures to protect your information from unauthorized access, disclosure, alteration, or destruction. However, no data transmission over the internet or wireless network can be guaranteed to be 100% secure."),
              SizedBox(height: 5,),
              Row(
                children: [
                  Text("Changes to this Privacy Policy",style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 5,),
              Text("We may update this Privacy Policy from time to time. When we do, we will revise the \"Effective Date\" at the top of this Privacy Policy. We encourage you to review this Privacy Policy periodically."),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Contact Us",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ],
              ),
              SizedBox(height: 10,),
              Text("If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:"),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Gift University\nE-Architect\nabbasusman753@gmail.com",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 20,)
            ],
          ),
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
