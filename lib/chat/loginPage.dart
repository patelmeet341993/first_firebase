import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatpage.dart';
import 'constantdata.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtname = TextEditingController();
  TextEditingController txtid = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return mainBody();
  }


  void saveData()async{
    print("saving....");

    String nm=txtname.text;
    String id=txtid.text;

    Constants.username=nm;
    Constants.userid=id;


    print("saved.");

    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ChatPage()));


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

                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: (){
                    saveData();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                    color: Colors.blue,
                    child: Text("Login"),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
