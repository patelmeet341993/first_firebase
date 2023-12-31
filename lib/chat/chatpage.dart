import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      data["sender"] = Constants.userid;
      data["senderName"] = Constants.username;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: map['sender']==Constants.userid?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            map["senderName"],
            style: TextStyle(fontSize: 15),
          ),
          Text(map["msg"],style: TextStyle(fontSize: 20),),

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
            Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Constants.username,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(Constants.userid,
                    style: TextStyle(fontSize: 16, color: Colors.white))
              ],
            ),
          ],
        ));
  }
}
