import 'package:flutter/material.dart';
import 'package:journaling_app/pages/Authentication/authentication.dart';
import 'package:journaling_app/pages/Journals/home.dart';
import 'package:journaling_app/pages/Navigation/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationPage(),
    );
  }
}