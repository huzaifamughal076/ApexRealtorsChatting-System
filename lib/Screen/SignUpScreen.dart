import 'package:apex_realtors_chatting_system/DB/auth_services.dart';
import 'package:apex_realtors_chatting_system/Screen/HomeScreen.dart';
import 'package:apex_realtors_chatting_system/SharedPreferences/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController TextNameController = TextEditingController();
  TextEditingController TextEmailController = TextEditingController();
  TextEditingController TextPhoneController = TextEditingController();
  TextEditingController TextPasswordController = TextEditingController();
  TextEditingController TextConfirmPasswordController = TextEditingController();
  var Email, Password, Name, C_Password, Phone;

  bool viewVisible = false;
  bool _isLoading =false;
  bool _isObscurePassword = true;
  bool _isObscureConPassword = true;
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final formkey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: _isLoading?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)):
      Form(
        key: formkey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("Apex Realtors",style:GoogleFonts.alfaSlabOne(fontSize: 25),)),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/apex_logo.png",width: 100,height: 100,),
                ),
                SizedBox(height: 30,),
                Text("SIGN UP",style: GoogleFonts.robotoCondensed(fontSize: 20,fontWeight: FontWeight.bold),),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 50, 15, 0),
                  child: TextFormField(
                    controller: TextNameController,
                    validator: (TextNameController) {
                      if (TextNameController!.isEmpty || TextNameController == null) {
                        return "Name Required";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (TextNameController){
                      Name = TextNameController;
                      print(Name);
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color: Color(0xff616E8F),),
                      hintText: "Name",
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: TextFormField(
                    controller: TextEmailController,
                    validator: (TextEmailController) {
                      if (TextEmailController!.isEmpty || TextEmailController == null) {
                        return "Email Required";
                      } else if (!emailValid.hasMatch(TextEmailController)) {
                        return "Email format not correct";
                      } else {

                        return null;
                      }
                    },
                    onChanged: (TextEmailController){
                      Email = TextEmailController;
                      print(Email);
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
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: TextFormField(
                    controller: TextPhoneController,
                    validator: (TextPhoneController) {
                      if (TextPhoneController!.isEmpty || TextPhoneController == null) {
                        return "Phone Required";
                      } else {

                        return null;
                      }
                    },
                    onChanged: (TextPhoneController){
                      Phone = TextPhoneController;
                      print(Phone);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone,color: Color(0xff616E8F),),
                      hintText: "Phone",
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: TextFormField(
                    controller: TextPasswordController,
                    validator: (TextPasswordController) {
                      if (TextPasswordController!.isEmpty || TextPasswordController == null) {
                        return "Password Required";
                      } else if (TextPasswordController.length < 6) {
                        return "Password should be greater then 6 characters";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (TextPasswordController){
                      Password = TextPasswordController;
                      print(Password);
                    },
                    keyboardType: TextInputType.text,
                    obscureText: _isObscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock,color: Color(0xff616E8F),),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscurePassword ? Icons.visibility : Icons.visibility_off),
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
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: TextFormField(
                    controller: TextConfirmPasswordController,
                    validator: (TextConfirmPasswordController) {
                      if (TextConfirmPasswordController!.isEmpty ||
                          TextConfirmPasswordController == null) {
                        return "Confirm Password Required";
                      } else if (TextConfirmPasswordController != Password) {
                        return "Passwords don't match";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (TextConfirmPasswordController){
                      C_Password = TextConfirmPasswordController;
                      print(C_Password);
                    },
                    keyboardType: TextInputType.text,
                    obscureText: _isObscureConPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock,color: Color(0xff616E8F),),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscureConPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscureConPassword = !_isObscureConPassword;
                          });
                        },
                      ),
                      hintText: "Confirm Password",
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    register();
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40,10,40,10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent
                    ),
                    child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                  ),
                ),

                // InkWell(
                //   onTap: (){
                //     register();
                //   },
                //   child: Container(
                //     margin: EdgeInsets.all(30),
                //     padding: EdgeInsets.all(30),
                //     decoration: BoxDecoration(
                //       color: Colors.amber
                //     ),
                //     child: Text("Sign Up"),
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

   register()async {
    if(formkey.currentState != null &&formkey.currentState!.validate())
      {
        setState(() {
          _isLoading = true;
        });
        print("Running UP");
        await authService.registerUserWithEmailAndPassword(Name, Email, Phone, Password).then((value) async{
        if(value==true)
          {
            //saving the sharedPreference state
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserNameSF(Name);
            await HelperFunctions.saveUserEmailSF(Email);
            await HelperFunctions.saveUserPhoneSF(Phone);
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
