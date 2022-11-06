import 'package:apex_realtors_chatting_system/DB/DatabaseServices.dart';
import 'package:apex_realtors_chatting_system/DB/auth_services.dart';
import 'package:apex_realtors_chatting_system/Screen/SignUpScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../SharedPreferences/helper_function.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var Email, Password;
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _isObscurePassword = true;
  bool _isLoading =false;

  AuthService authService = AuthService();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)):
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Form(
            key: formkey,
            child: Column(
              children: [

                Center(child: Text("Apex Realtors",style:GoogleFonts.alfaSlabOne(fontSize: 25),)),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/apex_logo.png",width: 100,height: 100,),
                ),
                SizedBox(height: 30,),
                Text("LOGIN",style: GoogleFonts.robotoCondensed(fontSize: 20,fontWeight: FontWeight.bold),),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (emailController) {
                      if (emailController!.isEmpty || emailController == null) {
                        return "Email Required";
                      } else if (!emailValid.hasMatch(emailController)) {
                        return "Email format not correct";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (emailController){
                      setState(() {
                        Email = emailController;
                        print(Email);
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email,color: Color(0xff616E8F),),
                      hintText: "Email",
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (passwordController) {
                      if (passwordController!.isEmpty || passwordController == null) {
                        return "Password Required";
                      } else if (passwordController.length < 6) {
                        return "Password should be greater then 6 characters";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (passwordController){
                      setState(() {
                        Password = passwordController;
                        print(Password);
                      });
                    },
                    keyboardType: TextInputType.text,
                    obscureText: _isObscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock,color: Color(0xff616E8F),),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscurePassword = !_isObscurePassword;
                          });
                        },
                      ),
                      hintText: "Password",
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30,),
               
               InkWell(
                 onTap: (){
                  if (formkey.currentState != null &&formkey.currentState!.validate())
                  {
                  login();
                  } else
                  {
                  return;
                  }
                 },
                 child: Container(
                   padding: EdgeInsets.fromLTRB(40,10,40,10),
                   margin: EdgeInsets.all(10),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                   color: Colors.blueAccent
                   ),
                   child: Text("Login",style: TextStyle(color: Colors.white),),
                 ),
               ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Create a new Account ",style: TextStyle(color: Colors.black),),


                      InkWell(
                        onTap: (){
                          Get.to(SignUpScreen());
                        },
                          child: Text("Click Here",style: TextStyle(color: Colors.blue),)),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      )
    );
  }

   login() async{
     if(formkey.currentState != null &&formkey.currentState!.validate())
     {
       setState(() {
         _isLoading = true;
       });
       print("Running UP");
       await authService.LoginUserWithEmailAndPassword( Email,  Password).then((value) async{
         if(value==true)
         {
           QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).GettingUserData(Email);

           //saving the sharedPreference state
           await HelperFunctions.saveUserLoggedInStatus(true);
           await HelperFunctions.saveUserNameSF(snapshot.docs[0]['name']);
           print("Hwllllo"+snapshot.docs[0]['name']);
           await HelperFunctions.saveUserEmailSF(Email);
           await HelperFunctions.saveUserPhoneSF(snapshot.docs[0]['phone']);
           Get.offAll(HomeScreen());
         }
         else{
           Get.snackbar("Alert", value);
           setState(() {
             _isLoading = false;
           });
         }
       });
     }
   }
}
