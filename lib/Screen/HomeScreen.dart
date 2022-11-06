import 'package:apex_realtors_chatting_system/DB/auth_services.dart';
import 'package:apex_realtors_chatting_system/Screen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: Text("Home Screen"),
          ),

          ElevatedButton(onPressed: (){
            authService.signout();
            Get.offAll(LoginScreen());

          }, child: Text("Sign Out")),
        ],
      ),
    );
  }
}
