import 'package:apex_realtors_chatting_system/Screen/HomeScreen.dart';
import 'package:apex_realtors_chatting_system/Screen/Onborading.dart';
import 'package:apex_realtors_chatting_system/Screen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';


void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
       home: SplashScreen(),
    );

  }
}
