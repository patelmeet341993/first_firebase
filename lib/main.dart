import 'package:firebase_core/firebase_core.dart';
import 'package:first_firebase/chat/chatpage.dart';
import 'package:first_firebase/chat/google_login.dart';
import 'package:first_firebase/chat/signUp.dart';
import 'package:first_firebase/chat/splashscreen.dart';
import 'package:first_firebase/full_chat/myprovider.dart';
import 'package:first_firebase/full_chat/splashpage.dart';
import 'package:first_firebase/ln.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'first_page.dart';
import 'get_page.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );




  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
      ],
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MySplashScreen()
    );
  }
}

