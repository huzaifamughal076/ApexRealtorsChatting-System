import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:apex_realtors_chatting_system/Screen/HomeScreen.dart';
import 'package:apex_realtors_chatting_system/Screen/Onborading.dart';
import 'package:flutter/material.dart';

import '../SharedPreferences/helper_function.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _isSignedIn = false;


  @override
  void initState() {
  getUSerLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen( splash:"assets/images/apex_logo.png",
        nextScreen: _isSignedIn?HomeScreen():Onboarding());



  }

  getUSerLoggedInStatus()async{
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if(value!=null)
      {
        setState(() {
          _isSignedIn=value;
        });
      }
    });
  }

}
