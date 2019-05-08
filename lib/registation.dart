import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
class RegistaTion extends StatefulWidget {
  @override
  _RegistaTionState createState() => new _RegistaTionState();
}

class _RegistaTionState extends State<RegistaTion> {




  final _formKey = GlobalKey<FormState>();
  String name="";
  String pname="";
  String mname="";
  String phone="";
  String email="";
  String fname = "";
  String fid = "";
  String femail = "";
  String fimage = "";
  File sampleImage;
 String url="";
 String base="";

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
      base=basename(sampleImage.path);

    });


  }
  final TextEditingController _ncontroller = new TextEditingController();
  final TextEditingController _pcontroller = new TextEditingController();
  final TextEditingController _mcontroller = new TextEditingController();
  final TextEditingController _ppcontroller = new TextEditingController();
  final TextEditingController _econtroller = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 100),(){
      _getCurrentUserName();
    });
    super.initState();
  }

  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
   fname = user.displayName;
    fid = user.uid;
    femail = user.email;
    fimage = user.photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    void _onLoading( bool t) {
      if(t) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context){
              return SimpleDialog(
                children: <Widget>[
                  new Container(height: 50, width: 50, child: new CircularProgressIndicator()),
                  Text("Don't press back button data is processing !")
                ],
              );
            }
        );
      }else {
        Navigator.pop(context); //pop dialog
      }
    }


    void upload() async{
      _onLoading(true);
      if (_formKey.currentState.validate()) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      final StorageReference ref = FirebaseStorage.instance.ref().child(base);
      final StorageUploadTask uploadTask = ref.putFile(sampleImage);
      var downloadUrl = (await uploadTask.onComplete).ref.getDownloadURL();
      String urls = (await ref.getDownloadURL()).toString();

      url=urls;
      print(url);



        _formKey.currentState.save();

        // If the form is valid, display a snackbar. In the real world, you'd
        // often want to call a server or save the information in a database

        Map<String, String> data = <String, String>{
          "name": name,
          "email": email,
          "fathername":pname,
          "mother":mname,
          "phone":phone,
          "image":url,


        };
        Firestore.instance.collection(fid).document(phone).setData(data).whenComplete(() {
          _onLoading(false);
          _ncontroller.clear();
          _mcontroller.clear();
          _pcontroller.clear();
          _ppcontroller.clear();
          _econtroller.clear();
          setState(() {
            sampleImage=null;
          });

          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text('Data saved in firebase')));
        }).catchError((e) =>

            Scaffold
                .of(context)

                .showSnackBar(SnackBar(content: Text('Connection Error Try Again plz'))));
      }else{
        _onLoading(false);
      }




    }
    return new Scaffold(
      

      body: Card(

        elevation: 2,
        child: Form(
          key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(4),
              scrollDirection: Axis.vertical,
          children: <Widget>[



            Center(
              child: Text("Registation Form",style: TextStyle(fontSize: 20,),),
            ),


           Container(


               child:  GestureDetector(
                 onTap: (){
                   getImage();



                 },
                 child: sampleImage == null ?Image.asset("add.png",height: 100,width: 150,) :

                 Image.file(sampleImage,height: 100,width: 150),
               ),
             ),
           


            Card(elevation: 3,
            child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  labelText: 'Student Name',
                  hintText: ' ex:- Abhay..',
                  prefixIcon: Icon(Icons.person),

                ),
              keyboardType: TextInputType.text,
              controller: _ncontroller,
              validator: validateName,
              onSaved: (String val) {
                name = val;
              },

            ),
            ),

            Card(elevation: 3,
              child:  TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    labelText: 'Father Name',
                    hintText: ' ex:- Mr..',
                    prefixIcon: Icon(Icons.people_outline),
                  ),
                keyboardType: TextInputType.text,
                controller: _pcontroller,
                validator: validateName,
                onSaved: (String val) {
                  pname = val;
                },
              ),
            ),
            Card(elevation: 3,
              child:  TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mother Name',
                  hintText: ' ex:- Mr..',
                  prefixIcon: Icon(Icons.people_outline),
                ),
                controller: _mcontroller,
                keyboardType: TextInputType.text,
                validator: validateName,
                onSaved: (String val) {
                  mname = val;
                },
              ),
            ),


            Card(elevation: 3,

              child:  TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    hintText: ' ex:- 7074..',
                    prefixIcon: Icon(Icons.phone),

                  ),
                controller: _ppcontroller,
                keyboardType: TextInputType.number,
                validator: validateMobile,
                onSaved: (String val) {
                  phone = val;
                },
              ),
            ),
            Card(elevation: 3,

              child:  TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    labelText: 'Email Address',
                    hintText: ' ex:- ..@gmail.com',
                    prefixIcon: Icon(Icons.email),

                  ),
                keyboardType: TextInputType.emailAddress,
                controller: _econtroller,
                validator: validateEmail,
                onSaved: (String val) {
                  email = val;
                },
              ),

            ),






          ],

        )),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        upload();




      },child: Icon(Icons.save),
        heroTag: "btne",
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }
  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }


}

