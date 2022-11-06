import 'package:apex_realtors_chatting_system/Screen/SplashScreen.dart';
import 'package:apex_realtors_chatting_system/SharedPreferences/helper_function.dart';
import 'package:apex_realtors_chatting_system/shared/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter/foundation.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb)
    {
      //run the web initialization
      await Firebase.initializeApp(options: FirebaseOptions(
          apiKey: Constants.apiKey,
          appId: Constants.appId,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId));
    }
  else{
    await Firebase.initializeApp();
  }

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
       home: SplashScreen(),
    );

  }

}
