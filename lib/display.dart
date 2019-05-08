import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
class Display extends StatefulWidget {
  @override
  _DisplayState createState() => new _DisplayState();
}

class _DisplayState extends State<Display> {

  String name = "";
  String id = "";
  String email = "";
  String image = "";

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      setState(() {
        _getCurrentUserName();
      });

    });

    // TODO: implement initState
    super.initState();
  }

  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    name = user.displayName;
    id = user.uid;
    email = user.email;
    image = user.photoUrl;
  }

  @override
  Widget build(BuildContext context) {
return Hero(tag: "btn44", child:Scaffold(
  body: StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection(id).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting: return new Text('Loading...');
        default:
          return Hero(tag: "list", child: ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return new  Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(9),
                height: 130,
                child: Row(
                  children: <Widget>[

                    Expanded(child: Container(

                      child: Card(elevation: 6,child: Stack(
                        children: <Widget>[
                          /* Center(child: CircularProgressIndicator()),
                                Image.network('${article[position].urlToImage}',fit: BoxFit.fill,width: MediaQuery.of(context).size.width,)*/
                          Center(child: CircularProgressIndicator()),
                          FadeInImage.memoryNetwork(
                            fadeInDuration: const Duration(seconds: 2),
                            fadeInCurve: Curves.bounceIn,
                            placeholder: kTransparentImage,
                            image: document['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        ],
                      ),),
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
          ));
      }
    },
  ),


));
}

}
