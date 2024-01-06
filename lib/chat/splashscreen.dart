import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase/chat/signUp.dart';
import 'package:first_firebase/chat/numberpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'User.dart';
import 'chatpage.dart';
import 'constantdata.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? sharedPreferences;

  Future<void> checkLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();

    String? uid = sharedPreferences!.getString("uid");
    if (uid != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot snapshot =
          await firestore.collection("users").doc(uid).get();

      if (snapshot.exists) {


       Map<String,dynamic> data = snapshot.data() as Map<String, dynamic>;

       User user=User(name: data!["name"],userid: uid,imgUrl: data!["imageUrl"]);
       Constants.user=user;


       Navigator.push(context, MaterialPageRoute(builder: (ctx) => ChatPage()));



      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => NumberPage()));
      }


    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => NumberPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mainBody();
  }

  Widget _mainBody() {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SpinKitCircle(
          color: Colors.blue,
          size: 50,
        ),
      ),
    ));
  }
}
