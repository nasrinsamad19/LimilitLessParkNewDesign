import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/guide/option_screen.dart';
import 'package:limitlesspark_new/screens/guide/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashcreen extends StatefulWidget {
  const Splashcreen({Key? key}) : super(key: key);

  @override
  _SplashcreenState createState() => _SplashcreenState();
}

class _SplashcreenState extends State<Splashcreen> {
  @override
  void initState() {
    super.initState();
    loggedinfn();

    Timer(Duration(seconds: 7),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
            loggedin == null ? IntroScreen() : OptionScreen(),
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Center(
        child: Image.asset('assets/images/splash.gif'),

      ),
    );
  }
  var loggedin;

  loggedinfn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedin = prefs.getString('alreadyloggedin');
    });
  }
}
