import 'package:fininfo/screens/signin_page.dart';
import 'package:fininfo/wrapper/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
 /*   options: FirebaseOptions(
      apiKey: "AIzaSyCA7oocH2W1OMjKdCndNCNhEh8zqJX2KYE",
      authDomain: "login-app-3a92a.firebaseapp.com",
      databaseURL: "https://login-app-3a92a-default-rtdb.firebaseio.com",
      projectId: "login-app-3a92a",
      storageBucket: "login-app-3a92a.appspot.com",
      messagingSenderId: "982205682314",
      appId: "1:982205682314:web:c2bd99dfd166e0e6a31373",
    ),*/
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: AuthWrapper(),
      ),
    );
  }
}
