import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  GoogleSignInAccount? account;
  User? user;





  @override
  void initState() {
    super.initState();


    user=FirebaseAuth.instance.currentUser;


    // GoogleSignIn().isSignedIn().then((isLogin) {
    //   print("Login : $isLogin");
    //
    //   if (isLogin) {
    //     GoogleSignIn().signInSilently().then((userAccount) {
    //       account = userAccount;
    //       setState(() {});
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Future<void> doGoogleLogin() async {
    try {
      account = await GoogleSignIn().signIn();

      if (account != null) {
        print("login successfully");
        setState(() {});
        doFirebaseLogin();
      } else {
        print("not login");
      }
    } catch (e) {
      print("Error : $e");
    }
  }


  Future<void> doFirebaseLogin()async{

    try{



      GoogleSignInAuthentication authentication=await account!.authentication;
      FirebaseAuth auth=FirebaseAuth.instance;

      AuthCredential authCredential= GoogleAuthProvider.credential(
        accessToken:authentication.accessToken,
        idToken:authentication.idToken
      );


      UserCredential? userCredential=await auth.signInWithCredential(authCredential);

      if(userCredential!=null)
        {

         user= userCredential.user;
         setState(() {

         });

        }

    }
    catch(e)
    {
      print("Error : $e");
    }


  }

  Future<void> doLogout() async {
    try {

     await GoogleSignIn().disconnect();
     await FirebaseAuth.instance.signOut();
     user=null;
      setState(() {

      });


    } catch (e) {

      print("Error : $e");
    }
  }

  Widget _buildBody() {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) _googleAvt(),
            if (user != null) _logOutBtn(),
            if (user == null) _loginBtn(),
          ],
        ),
      ),
    ));
  }

  Widget _loginBtn() {
    return InkWell(
      onTap: () {
        doGoogleLogin();
      },
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(10),
        child: Text(
          "Login With Google",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _logOutBtn() {
    return InkWell(
      onTap: () {
        doLogout();
      },
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(10),
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _googleAvt() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Container(
              height: 100,
              width: 100,
              child: Image.network(user!.photoURL!)),
        ),
        Text(user!.displayName!),
        Text(user!.email!),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
