import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_firebase/full_chat/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'MyUserModel.dart';

class MyGroupChatPage extends StatefulWidget {
  const MyGroupChatPage({super.key});

  @override
  State<MyGroupChatPage> createState() => _MyGroupChatPageState();
}

class _MyGroupChatPageState extends State<MyGroupChatPage> {
  TextEditingController txtmsg = TextEditingController();

  late FirebaseFirestore firestore;
  List<Map<String, dynamic>> mylist = [];
  String msgCollectionId = "mygroupchat";
  ScrollController controller = ScrollController();

  late MyProvider provider;

  String groupName = "--";
  String groupImg = "";

  List<MyUserModel> users = [];
  String laststatus = "online";

  String? downloadUrl;
  File? imgFile;
  String imagelabel = "";
  bool isUploadingImg = false;

  Future<void> getUserList() async {
    firestore
        .collection("myusers")
        .orderBy("createdAt", descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((value) {
      List<DocumentSnapshot> docs = value.docs;

      users.clear();

      MyUserModel currentUser =
          Provider.of<MyProvider>(context, listen: false).usermodel!;

      print("current user : ${currentUser.uid}");

      for (int i = 0; i < docs.length; i++) {
        Map<dynamic, dynamic> data = docs[i].data() as Map;

        MyUserModel model = MyUserModel(
            name: data["name"],
            email: data["email"],
            imgurl: data["imgurl"],
            status: data["status"],
            uid: data["uid"]);

        users.add(model);
      }

      setState(() {});
    });
  }

  Future<void> setStatus(String status) async {
    laststatus = status;
    Map<String, dynamic> data = HashMap();
    data["status"] = status;
    data["createdAt"] = FieldValue.serverTimestamp();
    firestore.collection("myusers").doc(provider.usermodel!.uid).update(data);
  }

  Future<String> uploadImage() async {
    if (imgFile != null) {
      isUploadingImg = true;
      setState(() {});

      FirebaseStorage firebaseStorage = FirebaseStorage.instance;

      UploadTask uploadTask =
          firebaseStorage.ref("profile").child(imagelabel).putFile(imgFile!);

      TaskSnapshot taskSnapshot = await uploadTask.then((snap) => snap);

      if (taskSnapshot.state == TaskState.success) {
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
        isUploadingImg = false;
        setState(() {});
        return downloadUrl!;
      } else {
        print("can't upload");
        return "";
      }
    } else {
      return "";
    }
  }

  Future<void> sentMsg() async {
    String m = txtmsg.text;
    if (m.trim().isNotEmpty || imgFile != null) {
      Map<String, dynamic> data = new HashMap();

      data["msg"] = m;

      data["img"] = await uploadImage();
      data["createdAt"] = FieldValue.serverTimestamp();
      data["sender"] = provider.usermodel!.uid;
      data["senderName"] = provider.usermodel!.name;
      data["senderImage"] = provider.usermodel!.imgurl;
      await firestore.collection(msgCollectionId).doc().set(data);
      txtmsg.clear();
      imgFile = null;
      setState(() {});
      setStatus("online");
    }
  }

  Future<void> getGroupInfo() async {
    DocumentSnapshot snapshot =
        await firestore.collection("my groups").doc(msgCollectionId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      groupName = data["name"];
      groupImg = data["imgurl"];

      setState(() {});
    }
  }

  void getMsg() {
    firestore
        .collection(msgCollectionId)
        .orderBy("createdAt")
        .snapshots(includeMetadataChanges: true)
        .listen((data) {
      mylist.clear();
      for (int i = 0; i < data.docs.length; i++) {
        QueryDocumentSnapshot d = data.docs[i];
        Map<String, dynamic> mydata = d.data() as Map<String, dynamic>;
        mylist.add(mydata);
      }

      controller.jumpTo(controller.position.maxScrollExtent);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    getGroupInfo();
    getUserList();
    Future.delayed(Duration(milliseconds: 500), () {
      getMsg();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MyProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: _mainBody(),
      ),
    );
  }

  Widget usersList() {
    return Container(
      height: 70,
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      color: Colors.black87,
      child: ListView.builder(
          itemCount: users.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: users[index].status == "typing"
                          ? Colors.orange
                          : Colors.green),
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.all(2),
                  child: ClipOval(
                    child: groupImg.isEmpty
                        ? Icon(Icons.ac_unit)
                        : Image.network(users[index].imgurl),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  users[index].status,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: Colors.white),
                )
              ],
            );
          }),
    );
  }

  Widget _mainBody() {
    return Column(
      children: [_appBar(), usersList(), _msgBody(), _chatInput()],
    );
  }

  Widget _msgBody() {
    return Expanded(
        child: ListView.builder(
            controller: controller,
            itemCount: mylist.length,
            itemBuilder: (ctx, index) {
              return myItem(mylist[index]);
            }));
  }

  Future<void> pickImage() async {
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

  Widget _chatInput() {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.grey,
        ),
        Container(
          padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 10),
          child: Row(
            children: [
              isUploadingImg
                  ? SpinKitCircle(
                      size: 50,
                      color: Colors.black,
                    )
                  : InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.photo,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: imgFile != null
                                ? Colors.black
                                : Colors.blueGrey),
                      ),
                    ),
              Expanded(
                  child: TextField(
                onChanged: (val) {
                  if (val.isEmpty) {
                    if (laststatus != "online") setStatus("online");
                  } else {
                    if (laststatus != "typing") setStatus("typing");
                  }
                },
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
        ),
      ],
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
        mainAxisAlignment: map['sender'] != provider.usermodel!.uid
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (map['sender'] != provider.usermodel!.uid)
            Container(
                margin: EdgeInsets.only(right: 10),
                width: 30,
                height: 30,
                child: ClipOval(child: Image.network(map["senderImage"]))),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: map['sender'] == provider.usermodel!.uid
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  map["senderName"],
                  style: TextStyle(fontSize: 15),
                ),
                if (map.containsKey("img") && map["img"].toString().isNotEmpty)
                  Image.network(
                    map["img"],
                  ),
                Text(
                  map["msg"],
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          if (map['sender'] == provider.usermodel!.uid)
            Container(
                margin: EdgeInsets.only(left: 10),
                width: 30,
                height: 30,
                child:
                    ClipOval(child: Image.network(provider.usermodel!.imgurl)))
        ],
      ),
    );
  }

  Widget _appBar() {
    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.black87,
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                )),
            SizedBox(
              width: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              height: 45,
              width: 45,
              padding: EdgeInsets.all(1),
              child: ClipOval(
                child: groupImg.isEmpty
                    ? Icon(Icons.ac_unit)
                    : Image.network(groupImg),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                // Text(provider.usermodel!.status,
                //     style: TextStyle(fontSize: 16, color: Colors.white))
              ],
            ),
          ],
        ));
  }
}
