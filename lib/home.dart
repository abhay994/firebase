import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registation.dart';
import 'display.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:transparent_image/transparent_image.dart';
class myhome extends StatefulWidget {
  @override
  _myhomeState createState() => new _myhomeState();
}

class _myhomeState extends State<myhome> with SingleTickerProviderStateMixin {
  String name = "";
  String id = "";
  String email = "";
  String image = "";
  TabController _tabController;



  @override
  void initState() {

    Future.delayed(Duration(milliseconds: 100)).then((_) {
      setState(() {
        _getCurrentUserName();
      });
      _tabController =
      new TabController(vsync: this, initialIndex: 0, length: 2);
    });

    // TODO: implement initState
    super.initState();
  }
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    name = user.displayName;
    id = user.uid;
    email = user.email;
    image = user.photoUrl;
  }

bool btn=true;

  _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

   void _signout(){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child:
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 6,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(image),
        ),
        title: Text(
          name, style: TextStyle(color: Colors.black, fontSize: 12.0),),
        actions: <Widget>[
          FlatButton(onPressed: () {



            _signout();

          }, child: Text("Signout"))
        ],


        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.dashboard),
            ),
            new Tab(icon: new Icon(Icons.folder_special)),

          ],),
      ),
      body: new TabBarView(
        controller: _tabController,

        children: <Widget>[
          RegistaTion(),
       record()
        ],
      ),

    )


        , onWillPop: () {
          if (FirebaseAuth.instance.currentUser() != null) {

          } else {
            Navigator.pop(context);
          }
        });
  }



  Widget record() {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new  Container(
                  color: Colors.transparent,
                    padding: EdgeInsets.all(9),
                    height: 130,
                  child: Row(
                    children: <Widget>[

                      Expanded(child: Container(

                        child: Card(elevation: 6,child: Image.network(document['image'],fit: BoxFit.fill,width: double.infinity,height: double.infinity,),),
                      ),flex: 2),
                      Expanded(child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(child: Container(

                              child: Row(children: <Widget>[
                                Icon(Icons.person),
                                Text(document['name'].toString().toUpperCase(),
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                decorationStyle: TextDecorationStyle.wavy)),
                              ],),
                            ),flex: 3,
                            ),
                            Expanded(child: Container(
                              child: Row(children: <Widget>[
                                Icon(Icons.people),
                                Text(document['fathername'].toString().toUpperCase()),
                              ],) ,

                            ),flex: 3,
                            ),
                            Expanded(child: Container(

                              child: Row(children: <Widget>[
                                Icon(Icons.people),
                                Text(document['mother'].toString().toUpperCase()),
                              ],),
                            ),flex: 3,
                            ),
                            /*Row(children: <Widget>[
                              Icon(Icons.people),
                              Text(document['fathername']),
                            ],),
                            Row(children: <Widget>[
                              Icon(Icons.people),
                              Text(document['mother']),
                            ],),*/


                          ],
                        ),

                      ),flex: 4,
                      ),
                      Expanded(child: Container(

                        child: Column(
                          children: <Widget>[
                          Expanded(child: Container(

                child: FloatingActionButton(onPressed: (){
                  Firestore.instance.collection(id).document(document['phone']).delete();
                },child: Icon(Icons.delete),backgroundColor: Colors.black,),
                )),
                            Expanded(child: Container(

                              child: FloatingActionButton(onPressed: (){
                                launch('tel:'+document['phone']);

                              },child: Icon(Icons.call),backgroundColor: Colors.green,),
                            )),


                Expanded(child: Container(

                  child: FloatingActionButton(onPressed: (){
                    launch('mailto:'+document['email']);
                  },child: Icon(Icons.email),backgroundColor: Colors.red,),
                )),



                          ],
                        ),
                      ),flex: 2),
                    ],
                  ),

                 /*   child: Column(
                      children: <Widget>[
                        RaisedButton(onPressed: (){
                       Firestore.instance.collection(id).document(document['phone']).delete();
                        },
                          child: Text("click"+document['phone']),
                        )
                      ],
                    ),*/



                );



                /*ListTile(

                  title: new Text(document['name']),
                  subtitle: new Text(document['email']),
                );*/
              }).toList(),
            );
        }
      },
    );
  }
}