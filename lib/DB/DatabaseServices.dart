import 'package:apex_realtors_chatting_system/Screen/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  //reference for our collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");


  //Saving the userData
Future SavingUserData(String name, String email,String phone) async{

  return await userCollection.doc(uid).set({
    "name":name,
    "email":email,
    "phone":phone,
    "groups":[],
    "profilePic":"",
    "userid":uid,
  });
}

  //Getting UserData
Future GettingUserData(String email)async{
  QuerySnapshot snapshot = await userCollection.where("email",isEqualTo: email).get();
  return snapshot;
}
//getting user groups
GettingUserGroups()async{
  return userCollection.doc(uid).snapshots();
}
//creating a group
Future createGroup(String userName, String id, String groupName) async{

  DocumentReference groupDocumentReference = await groupCollection.add({
    "groupName": groupName,
    "groupIcon": "",
    "admin": "${id}_$userName",
    "member": [],
    "groupId": "",
    "recentMessage": "",
    "recentMessageSender":"",
  });
  //update the members
  await groupDocumentReference.update({
    "member":FieldValue.arrayUnion(["${uid}_$userName"]),
    "groupId":groupDocumentReference.id,
  });
  DocumentReference userDocumentReference =  userCollection.doc(uid);
  return await userDocumentReference.update({
    "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
  });
}

//Get the chat
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }
//Get the Admin
  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

//Get Group Memebers
getGroupMembers(String groupId)async{
  return groupCollection.doc(groupId).snapshots();
}

//Seach
searchByName(String groupName){
  return groupCollection.where("groupName",isEqualTo: groupName).get();

}
//fucntion -> bool
Future<bool> isUserJoined(String groupname, String groupId, String userName)async
{
  DocumentReference userdocumentRef = userCollection.doc(uid);
  DocumentSnapshot documentSnapshot = await userdocumentRef.get();
  List<dynamic> groups =await documentSnapshot['groups'];
  if(groups.contains("${groupId}_$groupname")){
    return true;
  }
  else{
    return false;
  }

}
//toggling the group join/exit
Future toggleGroupJoin(String groupId, String userName, String groupName)async{
  //doc reference
  DocumentReference userdocumentReference = userCollection.doc(uid);
  DocumentReference groupDocumentReference = groupCollection.doc(groupId);

  DocumentSnapshot documentSnapshot = await userdocumentReference.get();
  List<dynamic> groups =await documentSnapshot['groups'];
  //if user has our groups than than can remove them Can re-join it
    if(groups.contains("${groupId}_$groupName"))
      {
        await userdocumentReference.update({
          "groups":FieldValue.arrayRemove(["${groupId}_$groupName"])
        });
        await groupDocumentReference.update({
          "member":FieldValue.arrayRemove(["${uid}_$userName"])
        });

      }
    else{
      await userdocumentReference.update({
        "groups":FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "member":FieldValue.arrayUnion(["${uid}_$userName"])
      });


    }

}
Future GroupExit(String groupId, String userName, String groupName)async{
  //doc reference
  DocumentReference userdocumentReference = userCollection.doc(uid);
  DocumentReference groupDocumentReference = groupCollection.doc(groupId);

  DocumentSnapshot documentSnapshot = await userdocumentReference.get();
  List<dynamic> groups =await documentSnapshot['groups'];
  //if user has our groups than than can remove them Can re-join it
    if(groups.contains("${groupId}_$groupName"))
      {
        await userdocumentReference.update({
          "groups":FieldValue.arrayRemove(["${groupId}_$groupName"])
        });
        await groupDocumentReference.update({
          "member":FieldValue.arrayRemove(["${uid}_$userName"])
        });
        Fluttertoast.showToast(msg: "Can Sign Out");

        Get.offAll(HomeScreen());
      }
    else{
        Fluttertoast.showToast(msg: "Can't Sign Out");
    }

}

//send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}