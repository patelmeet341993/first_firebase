import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase/chat/signUp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'User.dart';
import 'chatpage.dart';
import 'constantdata.dart';

class NumberPage extends StatefulWidget {
  const NumberPage({super.key});

  @override
  State<NumberPage> createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  TextEditingController txtid = TextEditingController();
  TextEditingController txtpin = TextEditingController();


  bool isLogin=false;

  Map<String,dynamic>? data;

  String errorMsg="";


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



  void checkLogin()async{


    if(data!=null) {
      String id = txtid.text;
      String pin = txtpin.text;


      if(data!["pin"]!=pin)
        {

          errorMsg="Wrong Pin!";
          setState(() {

          });
          return;
        }



      User user=User(name: data!["name"],userid: id,imgUrl: data!["imageUrl"]);
      Constants.user=user;

      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      sharedPreferences.setString("uid", id);

      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ChatPage()));







    }



  }


  void checkNumber()async{
    print("saving....");


    String id=txtid.text;

    FirebaseFirestore firestore=FirebaseFirestore.instance;

    DocumentSnapshot snapshot=await  firestore.collection("users").doc(id).get();

    if(snapshot.exists)
      {
        print("exist");
        isLogin=true;

        data=snapshot.data() as Map<String,dynamic>;

        setState(() {

        });
      }
    else
      {
        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>SignupPage(number: id)));

      }





   // Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ChatPage()));


  }


  Widget mainBody() {
    return SafeArea(
        child: Scaffold(
          body: Container(
            width: double.maxFinite,
            child: Column(
              children: [

                Text("Enter id"),
                TextField(
                  controller: txtid,
                  keyboardType:TextInputType.number,
                ),

                if(isLogin)Text("Enter Pin"),
                if(isLogin)TextField(
                  controller: txtpin,
                  keyboardType:TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter your Pin"),
                ),


                Text(errorMsg),

                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: (){
                   isLogin? checkLogin() :  checkNumber();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                    color: Colors.blue,
                    child: Text(isLogin?"Login":"Check Number"),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
