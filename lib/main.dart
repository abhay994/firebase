import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

import 'sign.dart';
void main() {

  runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Sample(),

      theme: ThemeData(
          primaryColor: new Color(0xffffffff),
          accentColor: new Color(0xff000000)
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

      ),
    );
  }
}



class Sample extends StatefulWidget {
  @override
  _SampleState createState() => new _SampleState();
}

class _SampleState extends State<Sample> {
  String name;
  String fname = "";
  String fid = "";
  String femail = "";
  String fimage = "";


  void initState() {
    // TODO: implement initState
    _getCurrentUserName();
    Future.delayed(Duration(milliseconds: 200)).then((_) {
    if(name!=null) {


        routing();



    }else{
      routingh();
    }
          });
          super.initState();




  }
  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
 name= user.displayName;
  }


  void routing() async{
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => myhome()));
  }
  void routingh() async{
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
   color: Colors.white,


    );
  }
}




