import 'package:chat_web/views/webpage/chatroom.dart';
import 'package:chat_web/views/webpage/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WebChat extends StatelessWidget {
  final SizingInformation constraint;
  WebChat({Key key, @required this.constraint}) : super(key: key);

  QuerySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 4)
        ]),
        alignment: Alignment.center,
        width: constraint.screenSize.width,
        height: constraint.screenSize.height,
        child: Row(
          children: [
            Container(
                width: constraint.screenSize.width * 0.25,
                alignment: Alignment.center,
                child: ChatRoom(constraint: constraint)),
            Expanded(
              child: Container(
                width: constraint.screenSize.width * 0.7,
                alignment: Alignment.center,
                child: ConversationScreen(
                  constraint: constraint,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
