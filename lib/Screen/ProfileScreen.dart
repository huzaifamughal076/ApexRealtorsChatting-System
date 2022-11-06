import 'package:apex_realtors_chatting_system/DB/auth_services.dart';
import 'package:apex_realtors_chatting_system/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  String username="";
  String email = "";
  String phone = "";
  ProfileScreen(this.username,this.email,this.phone,{Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff616E8F),
      ),

        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.all(30),
            height: MediaQuery.of(context).size.height*0.85,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(19)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                    radius: 50 ,child: Image.asset("assets/images/apex_logo.png",fit: BoxFit.fill,)),
                SizedBox(height: 10,),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Name",style: TextStyle(color:Colors.black,fontSize: 18),)),
                Container(
                  decoration: BoxDecoration(color: Color(0xffEEEEEE),borderRadius: BorderRadius.circular(19)),
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child:Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(widget.username.toString())),
                ),

                SizedBox(height: 10,),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Description",style: TextStyle(color:Colors.black,fontSize: 18),)),
                Container(
                  decoration: BoxDecoration(color: Color(0xffEEEEEE),borderRadius: BorderRadius.circular(19)),
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child:Container(
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        maxLength: 20,
                        maxLines: 1,

                        decoration: InputDecoration(
                          hintText: 'Write About You',
                        ),
                      ),
                  ),
                ),

                SizedBox(height: 10,),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Email",style: TextStyle(color:Colors.black,fontSize: 18),)),
                Container(
                  decoration: BoxDecoration(color: Color(0xffEEEEEE),borderRadius: BorderRadius.circular(19)),
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child:Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(widget.email.toString())),
                ),

                SizedBox(height: 10,),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Phone",style: TextStyle(color:Colors.black,fontSize: 18),)),
                Container(
                  decoration: BoxDecoration(color: Color(0xffEEEEEE),borderRadius: BorderRadius.circular(19)),
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child:Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(widget.phone.toString())),
                ),

                SizedBox(height: 10,),



              ],
            ),
          ),
        ),



      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children:<Widget>[
            Icon(Icons.account_circle,
              size: 150,
              color: Colors.grey[700],),
            SizedBox(height: 15,),
            Text(widget.username,textAlign: TextAlign.center,style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            Divider(height: 2,),
            ListTile(
              onTap: (){Get.offAll(HomeScreen(),transition: Transition.cupertino);},
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){

              },
              selectedColor: Color(0xff616E8F),
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text("Profile",style: TextStyle(color: Color(0xff616E8F)),),
            ),
            ListTile(
              onTap: ()async{
                Get.defaultDialog(
                  title: "Are you sure",
                  content: Text("You want to Log Out?"),
                  confirmTextColor: Color(0xff616E8F),
                  cancelTextColor: Colors.red,

                  confirm: InkWell(
                    onTap: (){
                      authService.signout();
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xff616E8F)
                        ),
                        child: Text("Yes",style: TextStyle(color: Colors.white),)),
                  ),
                  cancel: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black
                        ),
                        child: Text("No",style: TextStyle(color: Colors.white),)),
                  ),
                );
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Log Out",style: TextStyle(color: Colors.black),),
            )

          ],
        ),
      ),
    );
  }
}
