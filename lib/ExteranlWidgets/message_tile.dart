import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final int time;
  final bool sentByMe;

  const MessageTile(
      {Key? key,
        required this.message,
        required this.sender,
        required this.time,
        required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: widget.sentByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            child: ListTile(
              tileColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.purple,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
               widget.sender,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    child: Text(
                      widget.message,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    getTime(widget.time),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  getTime(var time){
    var dt = DateTime.fromMillisecondsSinceEpoch(time);

// 12 Hour format:
    var d12 = DateFormat('hh:mm a').format(dt);
    return d12;
  }
}