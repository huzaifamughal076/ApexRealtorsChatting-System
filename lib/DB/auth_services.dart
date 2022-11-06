import 'package:apex_realtors_chatting_system/DB/DatabaseServices.dart';
import 'package:apex_realtors_chatting_system/Screen/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../SharedPreferences/helper_function.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login

  Future LoginUserWithEmailAndPassword(String email, String password)
  async{

    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null)
      {

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;

    }
  }

  //register

Future registerUserWithEmailAndPassword(String name,String email,String phone, String password)
async{

  try {
    User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
       if(user!=null)
         {
           //call our database services to update the user data.

          await DatabaseService(uid: user.uid).SavingUserData(name, email, phone);
           return true;
         }
  } on FirebaseAuthException catch (e) {
    return e.message;

  }
}


  //signout
Future signout()async{

  try{
    await HelperFunctions.saveUserLoggedInStatus(false);
    await HelperFunctions.saveUserNameSF("");
    await HelperFunctions.saveUserEmailSF("");
    await HelperFunctions.saveUserPhoneSF("");
    await firebaseAuth.signOut();
    Get.offAll(LoginScreen());
  }catch (e)
  {
    return null;
  }
}
}