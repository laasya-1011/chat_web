import 'package:chat_web/helper/constants.dart';
import 'package:chat_web/services/database.dart';
import 'package:chat_web/utils/firebaseConstans.dart';
import 'package:chat_web/views/webpage/webchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chatroom.dart';

class ConversationScreen extends StatefulWidget {
  final String chatroomId;
  final SizingInformation constraint;
  const ConversationScreen({this.chatroomId, @required this.constraint});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController textEditingController = TextEditingController();
  final databaseMethods = Get.find<DatabaseMethods>();
  Stream<QuerySnapshot> chatMessageStream;

  QuerySnapshot snapshot;
  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    isSendByMe:
                        Constants.myName == snapshot.data.docs[index]['sendBy'],
                    constraint: widget.constraint,
                  );
                },
              )
            : Center(
                child: Container(
                  child: Text(
                    '      ',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              );
      },
    );
  }

  sendMessage() {
    if (textEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': textEditingController.text,
        'sendBy': Constants.myName,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatroomId, messageMap);
      setState(() {
        textEditingController.text = '';
      });
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatroomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.chatroomId != null
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.to(widget.constraint.isDesktop
                      ? WebChat(
                          constraint: widget.constraint,
                        )
                      : ChatRoom(constraint: widget.constraint));
                })
            : null,
        elevation: 0,
        backgroundColor:
            widget.chatroomId != null ? Color(0xff0BB674) : Colors.transparent,
        title: widget.chatroomId != null
            ? Text(
                widget.chatroomId
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              )
            : Text(''),
      ),
      body: widget.chatroomId != null
          ? msgwidget()
          : Stack(
              children: [
                Container(
                  // width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    'assets/color_splash_black.jpg',
                    fit: BoxFit.cover,
                    width: widget.constraint.screenSize.width,
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Center(
                  child: Container(
                    child: Text(
                      'Welcome \n to \n WebChat',
                      style: GoogleFonts.dancingScript(
                          fontSize: 140,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff0BB674)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget msgwidget() {
    return Container(
      child: Stack(
        //fit: StackFit.loose,
        children: [
          Container(
            width: widget.constraint.screenSize.width,
            height: widget.constraint.screenSize.height,
            child: Image.asset(
              'assets/bgimage.png',
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
            ),
          ),
          Container(
            // width: widget.constraint.screenSize.width,
            height: double.infinity,
            margin: const EdgeInsets.only(bottom: 55.0),
            child: chatMessageList(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              //width: widget.constraint.screenSize.width,
              height: widget.constraint.screenSize.height * 0.062,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                boxShadow: [
                  BoxShadow(offset: Offset(0, 0), color: Colors.blueGrey[400]),
                ],
              ),
              child: TextField(
                controller: textEditingController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          //print('send');
                          sendMessage();
                        },
                        child: Container(
                            width: 50,
                            height: widget.constraint.screenSize.height * 0.05,
                            margin: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[350],
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 0),
                                    color: Colors.blueGrey[400]),
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.send_sharp,
                              color: Colors.white,
                            ))),
                    contentPadding:
                        EdgeInsets.only(left: 10, top: 20, right: 10),
                    hintText: 'Message...',
                    hintStyle: TextStyle(
                      color: Colors.white54,
                    ),
                    border: InputBorder.none),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final SizingInformation constraint;
  MessageTile({this.message, this.isSendByMe, this.constraint});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraint.screenSize.width,
      // height: constraint.screenSize.height,
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: isSendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 13, bottom: 13, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: isSendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23)),
              gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0xff00FF00), const Color(0xff01DF01)],
              )),
          child: Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 17, color: Colors.black))),
    );
  }
}
