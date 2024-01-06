import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase/chat/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constantdata.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController txtmsg = TextEditingController();

  late FirebaseFirestore firestore;
  List<Map<String, dynamic>> mylist = [];

  Future<void> sentMsg() async {
    String m = txtmsg.text;
    if (m.trim().isNotEmpty) {
      Map<String, dynamic> data = new HashMap();

      data["msg"] = m;
      data["createdAt"] = FieldValue.serverTimestamp();
      data["sender"] = Constants.user!.userid;
      data["senderName"] = Constants.user!.name;
      data["senderImage"] = Constants.user!.imgUrl;
      await firestore.collection("chat").doc().set(data);
      txtmsg.clear();
    }
  }

  void getMsg() {
    firestore
        .collection("chat").orderBy("createdAt")
        .snapshots(includeMetadataChanges: true)
        .listen((data) {
      mylist.clear();
      for (int i = 0; i < data.docs.length; i++) {
        QueryDocumentSnapshot d = data.docs[i];
        Map<String, dynamic> mydata = d.data() as Map<String, dynamic>;
        mylist.add(mydata);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    firestore = FirebaseFirestore.instance;
    Future.delayed(Duration(milliseconds: 500), () {
      getMsg();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _mainBody(),
      ),
    );
  }

  Widget _mainBody() {
    return Column(
      children: [_appBar(), _msgBody(), _chatInput()],
    );
  }

  Widget _msgBody() {
    return Expanded(
        child: ListView.builder(
            itemCount: mylist.length,
            itemBuilder: (ctx, index) {
              return myItem(mylist[index]);
            }));
  }

  Widget _chatInput() {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: txtmsg,
          )),
          InkWell(
            onTap: () {
              sentMsg();
            },
            child: Container(
              height: 50,
              width: 50,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blueGrey),
            ),
          )
        ],
      ),
    );
  }



  Widget myItem(Map<String, dynamic> map) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
       // color: map['sender']==Constants.userid?Colors.blue:Colors.grey,
      ),
      child: Row(
        mainAxisAlignment:map['sender']!=Constants.user!.userid? MainAxisAlignment.start:MainAxisAlignment.end,
        children: [

          if(map['sender']!=Constants.user!.userid)Container(
              margin: EdgeInsets.only(right: 10),
              width: 30,
              height: 30,
              child: ClipOval(child: Image.network(map["senderImage"]))),


          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: map['sender']==Constants.user!.userid?CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: [



              Text(
                map["senderName"],
                style: TextStyle(fontSize: 15),
              ),
              Text(map["msg"],style: TextStyle(fontSize: 20),),


            ],
          ),

          if(map['sender']==Constants.user!.userid)Container(
              margin: EdgeInsets.only(left: 10),
              width: 30,
              height: 30,
              child: ClipOval(child: Image.network(Constants.user!.imgUrl)))

        ],
      ),
    );
  }


  Widget _appBar() {
    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.blueGrey,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              height: 60,
              width: 60,
              child: ClipOval(
                child: Image.network(
                    Constants.user!.imgUrl
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Constants.user!.name,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(Constants.user!.userid,
                    style: TextStyle(fontSize: 16, color: Colors.white))
              ],
            ),
            Spacer(),
            InkWell(
                onTap: ()async{
                  SharedPreferences shared=await SharedPreferences.getInstance();
                  shared.clear();

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>SplashScreen()));


                },
                child: Icon(Icons.logout))
          ],
        ));
  }
}
