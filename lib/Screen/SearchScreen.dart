import 'dart:developer';

import 'package:apex_realtors_chatting_system/DB/DatabaseServices.dart';
import 'package:apex_realtors_chatting_system/Screen/ChatScreen.dart';
import 'package:apex_realtors_chatting_system/SharedPreferences/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isJoined = false;
  bool hasUserSearched = false;
  QuerySnapshot? searchSnapshot;
  User? user;

  String userName="";


  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName()async{
    await HelperFunctions.getUserNameFromSF().then((value){
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }
  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff616E8F),

        title: Text("Search",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,

      ),

      body: Column(
        children: [
          Container(
            color: Color(0xff616E8F),
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              children: [
                Expanded(child: TextField(
                controller: searchController,
              style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search groups....",
                    hintStyle: TextStyle(color: Colors.white54,fontSize: 16),
                    border: InputBorder.none,
                  ),
            ),
                ),
                InkWell(
                  onTap: (){
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.search,color: Colors.white,),
                  ),
                ),
              ],
            ),

          ),
          isLoading
              ? Center(child: CircularProgressIndicator(
                color: Color(0xff616E8F)
                ))
              :groupList(),
        ],
      ),
    );
  }
  initiateSearchMethod()async{
    if(searchController.text.isNotEmpty)
      {
        setState(() {
          isLoading=true;
        });
        await DatabaseService().searchByName(searchController.text)
            .then((snapshot){
          setState(() {
            searchSnapshot = snapshot;
            isLoading= false;
            hasUserSearched = true;
          });
        });
      }

  }
  groupList(){
    return hasUserSearched
        ? ListView.builder(
          shrinkWrap: true,
          itemCount: searchSnapshot!.docs.length,
          itemBuilder: (context,index){
          return groupTile(
          userName,
          searchSnapshot!.docs[index]['groupId'],
          searchSnapshot!.docs[index]['groupName'],
          searchSnapshot!.docs[index]['admin'],
        );

        }):Container();
  }

  joinedOrNot(String userName,String groupName, String groupId, String admin)
 async{
  await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value) {
    setState(() {
      isJoined = value;
    });
  });
  }

  Widget groupTile(
      String userName, String groupId,String groupName, String admin)
  {
    //fucntion to check wheather user already joined or not
   joinedOrNot(userName,groupName,groupId,admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Color(0xff616E8F),
        child: Text(groupName.substring(0,1).toUpperCase(),
        style: TextStyle(color: Colors.white),),
      ),
      title: Text(groupName,style: TextStyle(fontWeight:FontWeight.w600 ),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: ()async{

          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
          if(isJoined)
            {
              setState(() {
                isJoined = !isJoined;
              });
              Get.snackbar("Successfully Joined the Group $groupName", "");
              Future.delayed(const Duration(seconds: 2),(){
                Get.to(ChatScreen(groupId: groupId, groupName: groupName, userName: userName));
              });
            }
          else{
            setState(() {
              isJoined = !isJoined;
            });
            Get.snackbar("Successfully Left the Group $groupName", "");
          }

        },
        child: isJoined? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white,width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Joined",style: TextStyle(color: Colors.white),),
        ):Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff616E8F),
            border: Border.all(color: Colors.white,width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Join",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

}
