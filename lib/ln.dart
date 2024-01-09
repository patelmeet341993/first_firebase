// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// GoogleSignIn _googleSignIn = GoogleSignIn();
//
// class LoginButtons extends StatefulWidget {
//   const LoginButtons({super.key});
//
//   @override
//   State<LoginButtons> createState() => _LoginButtonsState();
// }
//
// class _LoginButtonsState extends State<LoginButtons> {
//   GoogleSignInAccount? _currentUser;
//   bool _isAuthorized = false; // has granted permissions?
//   String _contactText = '';
//
//   @override
//   void initState() {
//     super.initState();
//
//
//    User? user= FirebaseAuth.instance.currentUser;
//    if(user==null)
//      {
//        print("not login");
//      }
//    else
//      {
//        print("login");
//      }
//
//     // _googleSignIn.onCurrentUserChanged
//     //     .listen((GoogleSignInAccount? account) async {
//     //   // In mobile, being authenticated means being authorized...
//     //   bool isAuthorized = account != null;
//     //   // However, in the web...
//     //
//     //
//     //   setState(() {
//     //     _currentUser = account;
//     //     _isAuthorized = isAuthorized;
//     //   });
//     //
//     //   if(_currentUser!=null)
//     //   {
//     //     print("login");
//     //   }
//     //   else{
//     //     print("not login");
//     //   }
//     // });
//
//     _googleSignIn.isSignedIn().then((value) {
//       _googleSignIn.signInSilently().then((value) {
//         _currentUser = _googleSignIn.currentUser;
//         setState(() {});
//       });
//       print("value $value");
//     });
//   }
//
//   Future<void> fireabseLogin() async {
//     try {
//       GoogleSignInAuthentication authentication =
//           await _currentUser!.authentication;
//       AuthCredential? cred;
//       try {
//         cred = GoogleAuthProvider.credential(
//             accessToken: authentication.accessToken,
//             idToken: authentication.idToken);
//       } catch (e) {
//         print(e);
//       }
//
//       FirebaseAuth auth = FirebaseAuth.instance;
//       UserCredential credential = await auth.signInWithCredential(cred!);
//       if (credential.user != null) {
//         print("firebase login ");
//       }
//     } on FirebaseAuthException catch (e) {
//       print("Code:${e.code}");
//     }
//   }
//
//   Widget _buildBody() {
//     final GoogleSignInAccount? user = _googleSignIn.currentUser;
//     if (user != null) {
//       // The user is Authenticated
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: user,
//               placeholderPhotoUrl: null,
//             ),
//             title: Text(user.displayName ?? ''),
//             subtitle: Text(user.email),
//           ),
//           const Text('Signed in successfully.'),
//           if (_isAuthorized) ...<Widget>[
//             // The user has Authorized all required scopes
//             Text(_contactText),
//             ElevatedButton(
//               child: const Text('REFRESH'),
//               onPressed: () {},
//             ),
//           ],
//           if (!_isAuthorized) ...<Widget>[
//             // The user has NOT Authorized all required scopes.
//             // (Mobile users may never see this button!)
//             const Text('Additional permissions needed to read your contacts.'),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('REQUEST PERMISSIONS'),
//             ),
//           ],
//           ElevatedButton(
//             onPressed: _handleSignOut,
//             child: const Text('SIGN OUT'),
//           ),
//         ],
//       );
//     } else {
//       // The user is NOT Authenticated
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           const Text('You are not currently signed in.'),
//           // This method is used to separate mobile from web code with conditional exports.
//           // See: src/sign_in_button.dart
//           MaterialButton(
//             child: Text("Login"),
//             onPressed: _handleSignIn,
//           ),
//         ],
//       );
//     }
//   }
//
//   Future<void> _handleSignOut()async {
//
//    await _googleSignIn.disconnect();
//    await FirebaseAuth.instance.signOut();
//
//   }
//
//   Future<void> _handleSignIn() async {
//     try {
//       GoogleSignInAccount? ac = await _googleSignIn.signIn();
//       if (ac != null) {
//         setState(() {
//           _currentUser = ac;
//           _isAuthorized = true;
//           fireabseLogin();
//         });
//       }
//     } catch (error) {
//       print(error);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Google Sign In'),
//         ),
//         body: ConstrainedBox(
//           constraints: const BoxConstraints.expand(),
//           child: _buildBody(),
//         ));
//   }
// }
