import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'User.dart';
import 'chatpage.dart';
import 'constantdata.dart';

class SignupPage extends StatefulWidget {
  final String number;

  const SignupPage({required this.number});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController txtname = TextEditingController();
  TextEditingController txtid = TextEditingController();
  TextEditingController txtpin = TextEditingController();
  String? downloadUrl;

  String imagelabel = "No image Selected";

  File? imgFile;

  @override
  void initState() {
    super.initState();
    txtid.text = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    return mainBody();
  }

  // void uploadImage()async{
  //   final FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: false,
  //   );
  //
  //
  //   if(result!=null) {
  //     Uri uri=Uri.parse(result!.files.first.path!);
  //     UploadTask uploadTask = FirebaseStorage.instance.ref("folder").child(result!.files.first.name)
  //         .putFile(File(result!.files.first.path!));
  //
  //     TaskSnapshot snapshot=await uploadTask.then((snapshot) => snapshot);
  //
  //     if(snapshot.state==TaskState.success)
  //     {
  //       downloadUrl=await snapshot.ref.getDownloadURL();
  //       print("url : $downloadUrl");
  //       setState(() {
  //
  //       });
  //     }
  //     else
  //     {
  //       print("not uploaded");
  //     }
  //
  //   }
  //   else {
  //     print("no file selecred");
  //   }
  //
  // }

  void imagePick() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      imgFile = File(result!.files.first.path!);
      imagelabel = result!.files.first.name;
      setState(() {});
    }
  }

  void saveData() async {
    print("saving....");

    if (imgFile != null) {
      String nm = txtname.text;
      String id = txtid.text;
      String pin = txtpin.text;

      FirebaseStorage firebaseStorage = FirebaseStorage.instance;

      UploadTask uploadTask =
          firebaseStorage.ref("profile").child(imagelabel).putFile(imgFile!);

      TaskSnapshot taskSnapshot = await uploadTask.then((snap) => snap);

      if (taskSnapshot.state == TaskState.success) {
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
      } else {
        print("can't upload");
      }

      Map<String,dynamic> data=new HashMap();
      data["userid"]=id;
      data["pin"]=pin;
      data["name"]=nm;
      data["imageUrl"]=downloadUrl;


      FirebaseFirestore firestore=FirebaseFirestore.instance;
      await firestore.collection("users").doc(id).set(data);


      User user=User(name: data!["name"],userid: id,imgUrl: data!["imageUrl"]);
      Constants.user=user;

      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      sharedPreferences.setString("uid", id);

      Navigator.push(context, MaterialPageRoute(builder: (ctx) => ChatPage()));
    }
  }

  Widget mainBody() {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: double.maxFinite,
        child: Column(
          children: [
            Text("Enter name"),
            TextField(
              controller: txtname,
            ),
            Text("Enter id"),
            TextField(
              controller: txtid,
            ),
            Text("Enter Pin"),
            TextField(
              controller: txtpin,
            ),
            InkWell(
              onTap: () {
                imagePick();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                color: Colors.blue,
                child: Text("Pic your Profile"),
              ),
            ),
            Text(imagelabel),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                saveData();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                color: Colors.blue,
                child: Text("Register"),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
