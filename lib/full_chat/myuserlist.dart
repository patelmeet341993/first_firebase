import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase/full_chat/chatscreen.dart';
import 'package:first_firebase/full_chat/groupchatscreen.dart';
import 'package:first_firebase/full_chat/myprovider.dart';
import 'package:first_firebase/full_chat/splashpage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'MyUserModel.dart';

class MyUserList extends StatefulWidget {
  const MyUserList({super.key});

  @override
  State<MyUserList> createState() => _MyUserListState();
}

class _MyUserListState extends State<MyUserList> {



  List<MyUserModel> users=[];

  @override
  void initState() {

    super.initState();
    getUserList();
  }


  @override
  Widget build(BuildContext context) {
    return _mainBody();
  }



  void getUserList()async{


    FirebaseFirestore.instance.collection("myusers").get().then((value) {


      List<DocumentSnapshot> docs=value.docs;

      users.clear();


      MyUserModel currentUser=Provider.of<MyProvider>(context,listen: false).usermodel!;

      print("current user : ${currentUser.uid}");

      for(int i=0;i<docs.length;i++)
        {

          Map<dynamic,dynamic> data=docs[i].data() as Map;


          MyUserModel model=MyUserModel(name: data["name"], email: data["email"], imgurl:data["imgurl"], status: data["status"], uid: data["uid"]);

          if(model.uid!=Provider.of<MyProvider>(context,listen: false).usermodel!.uid) {
            users.add(model);
          }
        }


      setState(() {

      });




    });



  }


  Future<void> doLogout()async{
    try {

      await GoogleSignIn().disconnect();
      await FirebaseAuth.instance.signOut();

      Navigator.push(context, MaterialPageRoute(builder: (ctx) => MySplashScreen()));



    } catch (e) {

      print("Error : $e");
    }
  }


  Widget myListView(){
    return ListView.builder(

        itemCount: users.length,
        itemBuilder: (ctx,index){

          return userItem(users[index]);


        });
  }

  Widget userItem(MyUserModel user)
  {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => MyChatPage(userModel: user)));

      },
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              child:Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    child: ClipOval(
                      child: Image.network(user.imgurl),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                      Text(user.status,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                    ],
                  )
                ],
              ),
            ),
            Container(width: double.maxFinite,height: 1,color: Colors.grey,),
          ],
        ),
      ),
    );
  }

  Widget _mainBody() {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.wechat),
        title: Text("My Chat Room"),
        actions: [InkWell(onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => MyGroupChatPage()));

        }, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.group),
        )),
          InkWell(onTap: () {

            doLogout();

          }, child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.logout),
          ))
        ],
      ),
      body: Container(
          child: Column(
        children: [

          Expanded(child: myListView())

        ],
      )),
    ));
  }
}
