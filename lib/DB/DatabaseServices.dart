import 'package:cloud_firestore/cloud_firestore.dart';

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


}