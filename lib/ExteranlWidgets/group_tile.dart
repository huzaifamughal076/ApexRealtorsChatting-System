import 'package:apex_realtors_chatting_system/Screen/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class GroupTile extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupName;
  const GroupTile({Key? key,required this.username, required this.groupId,required this.groupName}) : super(key: key);
  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(ChatScreen(groupId: widget.groupId, groupName: widget.groupName, userName: widget.username));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xff616E8F),
            child: Text(widget.groupName.substring(0,1).toUpperCase(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
          ),
          title: Text(widget.groupName,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.username}",style: TextStyle(fontSize:13 ),),
        )
      ),
    );
  }

}
