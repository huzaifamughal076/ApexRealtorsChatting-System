import 'package:apex_realtors_chatting_system/DB/auth_services.dart';
import 'package:apex_realtors_chatting_system/Screen/LoginScreen.dart';
import 'package:apex_realtors_chatting_system/Screen/ProfileScreen.dart';
import 'package:apex_realtors_chatting_system/Screen/SearchScreen.dart';
import 'package:apex_realtors_chatting_system/SharedPreferences/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String UserName="";
  String UserPhone ="";
  String Email ="";
  String Phone = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }
  gettingUserData()async{
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        Email = value!;
        print(Email);
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val){
      setState(() {
        UserName = val!;
        print(UserName);
      });
    });
    await HelperFunctions.getUserPhoneFromSF().then((va){
      setState(() {
        UserPhone = va!;
        print(UserPhone);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        actions: [IconButton(onPressed: (){
          Get.to(SearchScreen());
        }, icon: Icon(Icons.search))],
        backgroundColor: Color(0xff616E8F),
        title: Text("Groups",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 27),),
      ),

      body: Center(
        child: ElevatedButton(onPressed: ()async{
          await authService.signout();


      },child: Text("Sign Out"),),),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children:<Widget>[
            Icon(Icons.account_circle,
            size: 150,
                color: Colors.grey[700],),
            SizedBox(height: 15,),
            Text(UserName,textAlign: TextAlign.center,style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            Divider(height: 2,),
            ListTile(
              onTap: (){},
              selectedColor: Color(0xff616E8F),

              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",style: TextStyle(color: Color(0xff616E8F)),),
            ),
            ListTile(
              onTap: (){ Get.offAll(ProfileScreen(UserName,Email,UserPhone),transition: Transition.cupertino);

                },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text("Profile",style: TextStyle(color: Colors.black),),
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
