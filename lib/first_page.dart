import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TextEditingController txtname = TextEditingController();
  TextEditingController txtsem = TextEditingController();
  TextEditingController txtfield = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return mainBody();
  }


  void saveData()async{
    print("saving....");

    String nm=txtname.text;
    String sm=txtsem.text;
    String fd=txtfield.text;

    Map<String,dynamic> data=new HashMap();
    data["name"]=nm;
    data["sem"]=sm;
    data["field"]=fd;
    //data["createdAt"]=FieldValue.serverTimestamp();

    data["lastupdateAt"]=FieldValue.serverTimestamp();
      FirebaseFirestore firestore=FirebaseFirestore.instance;
      await firestore.collection("students").doc("jYfK6LA5RPmBdb6YpSSA").update(data);


      print("saved.");


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
            Text("Enter sem"),
            TextField(
              controller: txtsem,
            ),
            Text("Enter Field"),
            TextField(
              controller: txtfield,
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
                child: Text("Add Data"),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
