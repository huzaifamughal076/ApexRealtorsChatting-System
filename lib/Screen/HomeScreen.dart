import 'package:apex_realtors_chatting_system/DB/DatabaseServices.dart';
import 'package:apex_realtors_chatting_system/DB/auth_services.dart';
import 'package:apex_realtors_chatting_system/ExteranlWidgets/group_tile.dart';
import 'package:apex_realtors_chatting_system/Screen/LoginScreen.dart';
import 'package:apex_realtors_chatting_system/Screen/ProfileScreen.dart';
import 'package:apex_realtors_chatting_system/Screen/SearchScreen.dart';
import 'package:apex_realtors_chatting_system/SharedPreferences/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Stream? groups;
  bool _isLoading = false;
  String groupName="";

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
    //getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).GettingUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });
  }

  //String manipulation
  String getID(String res)
  {
    return res.substring(0,res.indexOf("_"));
  }
  String getName(String res){
    return res.substring(res.indexOf("_")+1);
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

      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Color(0xff616E8F),
        child: Icon(Icons.add),
      ),
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

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder:(context, AsyncSnapshot snapshot){
          //make some checks
          if(snapshot.hasData)
            {
              if(snapshot.data['groups']!=null)
                {
                  if(snapshot.data['groups'].length!=0)
                    {
                      return ListView.builder(
                          itemCount: snapshot.data['groups'].length,
                          itemBuilder: (context, index) {

                            int reverseIndex = snapshot.data['groups'].length-index-1;
                            //Fluttertoast.showToast(msg:snapshot.data['name'][reverseIndex] );
                            return GroupTile(
                             username: snapshot.data['name'], groupId: getID(snapshot.data['groups'][reverseIndex]), groupName: getName(snapshot.data['groups'][reverseIndex]));
                          });
                    }
                  else{
                    return noGroupWidget();
                  }


                }else{
                return noGroupWidget();
              }
            }
          else{
            return Center(child: CircularProgressIndicator(color: Color(0xff616E8F),));
          }
        }
    );
  }

  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child:
          InkWell(
            onTap: (){
              popUpDialog(context);
            },
              child: Icon(Icons.add_circle,color:Colors.grey[700],size: 75,))),
          SizedBox(height: 20,),
          Text("You have not joined any groups, tap on add to create a group or also from search button",textAlign: TextAlign.center,),

        ],
      ),
    );
  }

  popUpDialog(BuildContext context){
        return Get.defaultDialog(

            title: "Create a group",
            barrierDismissible: false,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true ? Center(child: CircularProgressIndicator(color: Color(0xff616E8F),),):
                TextField(
                  onChanged: (val){
                    setState(() {
                      groupName = val;
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff616E8F),),
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ),
              ],),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black
                  ),
                  onPressed: (){
                    Get.back();
                  }, child: Text("Cancel",style: TextStyle(color: Colors.white),)),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff616E8F),
                  ),
                  onPressed: ()async{
                    if(groupName!="")
                    {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(UserName, FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Get.back();
                      Get.snackbar("Alert", "Group created successfully");
                    }
                  },
                  child: Text("Create",style: TextStyle(color: Colors.white),)),
            ]
        );


  }

}