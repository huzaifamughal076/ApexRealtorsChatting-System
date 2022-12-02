import 'package:apex_realtors_chatting_system/DB/DatabaseServices.dart';
import 'package:apex_realtors_chatting_system/Screen/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfoScreen({Key? key,required this.groupId,required this.groupName, required this.adminName}) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  String userName ="";
  Stream? members;


@override
void initState() {
  getMembers();
  super.initState();
}
getMembers()async{
  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupMembers(widget.groupId).then((value){
    setState(() {
      members = value;
    });
  });
}
//String Manipulation
String getID(String res)
{
  return res.substring(0,res.indexOf("_"));
}
//String Manipulation
  String getName(String res){
  String cls = res.substring(res.indexOf("_")+1);
  userName = cls;
  return cls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Group Info"),
        backgroundColor: Color(0xff616E8F),
        actions: [
          IconButton(onPressed: ()async{
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(widget.groupId, userName, widget.groupName);
            Get.offAll(HomeScreen());

          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xff616E8F).withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xff616E8F),
                    child: Text(widget.groupName.substring(0,1).toUpperCase(),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group: ${widget.groupName}",style: TextStyle(fontWeight: FontWeight.w500),),
                      SizedBox(height: 5,),
                      Text("Admin: ${getName(widget.adminName)}",style: TextStyle(fontWeight: FontWeight.w500),)
                    ],
                  ),
                ],
              ),
            ),
      memberList(),
          ],
        ),
      ),
    );
  }

  memberList(){
  return StreamBuilder(
      stream: members,
      builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData)
          {
            if(snapshot.data['member']!=null)
              {
                if(snapshot.data['member'].length!=0)
                  {
                    return ListView.builder(
                      itemCount: snapshot.data['member'].length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xff616E8F),
                              child: Text(getName(snapshot.data['member'][index]).substring(0,1).
                              toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),
                              ),
                            ),
                            title: Text(getName(snapshot.data['member'][index])),
                            subtitle: Text(getID(snapshot.data['member'][index])),
                          ),
                        );

                    });
                  }
                else{
                  return Center(child: Text("No Members"),);
                }
              }
            else{
              return Center(child: Text("No Members"),);
            }
          }
        else{
          return Center(child: CircularProgressIndicator(color:Color(0xff616E8F)),);
        }

  });
  }

}
