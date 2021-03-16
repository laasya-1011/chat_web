import 'package:chat_web/helper/constants.dart';
import 'package:chat_web/helper/helperFunc.dart';
import 'package:chat_web/services/auth.dart';
import 'package:chat_web/services/database.dart';
import 'package:chat_web/views/tablet/TabPage.dart';
import 'package:chat_web/views/webpage/WebPage.dart';
import 'package:chat_web/views/webpage/conversation_screen.dart';
//import 'package:chat_web/views/webpage/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:chat_web/views/webpage/settings.dart';

class ChatRoom extends StatefulWidget {
  final SizingInformation constraint;
  const ChatRoom({Key key, @required this.constraint}) : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  // String search;
  final authMethod = Get.find<AuthMethod>();
  final databaseMethods = Get.find<DatabaseMethods>();
  //final searchText = Get.put(Search());
  Stream chatRooms;
  String q = "";
  TextEditingController searchController = TextEditingController();

  createChatRoomAndStartConversation(String username) {
    if (username != Constants.myName) {
      String chatRoomId = getChatroomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatroomMap = {
        'users': users,
        'chatroomId': chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatroomMap);
      Get.to(ConversationScreen(
        chatroomId: chatRoomId,
        constraint: widget.constraint,
      ));
    } else {
      print('you cannot send message to yourself');
    }
  }

  Widget searchList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("   "),
            );
          } else {
            List<DocumentSnapshot> list = snapshot.data.docs;
            if (q != "") {
              List<DocumentSnapshot> newList = [];

              for (var item in snapshot.data.docs) {
                if (item['name']
                    .toString()
                    .toLowerCase()
                    .contains(q.toLowerCase())) {
                  newList.add(item);
                  print(item['name']);
                } else {
                  // print("hello");
                }

                list = newList;
              }
            } else {
              list = snapshot.data.docs;
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return searchTile(
                  userName: list[index]['name'],
                  userEmail: list[index]['email'],
                );
              },
            );
          }
        });
  }

  Widget searchTile({String userName, final String userEmail}) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 7),
      child: ListTile(
        title: Text(
          userName,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          userEmail,
          style: TextStyle(fontSize: 18),
        ),
        onTap: () {
          createChatRoomAndStartConversation(userName);
        },
      ),
    );
  }

  getChatroomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  bool isSearching = false;
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.docs[index]['chatroomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.docs[index]["chatroomId"],
                    constraint: widget.constraint,
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    isSearching = false;
    setState(() {});
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserName();
    DatabaseMethods().getChatRooms(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(this.context);
    return Scaffold(
        // drawer:Container(width: widget.constraint.screenSize.width,height: double.infinity,child: Settings(),),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff0BB674),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              authMethod.signOut();

              if (widget.constraint.isDesktop) {
                Get.to(WebPage(
                  constraint: widget.constraint,
                ));
              } else {
                Get.to(TabPage(
                  constraint: widget.constraint,
                ));
              }
            },
          ),
          title: Text(
            'WidleChat',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                return showDialog(
                    context: context,
                    builder: (_) {
                      return PopScreen(constraint: widget.constraint);
                    });
              },
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.more_vert),
              ),
            )
          ],
        ),
        body: Container(
            width: widget.constraint.screenSize.width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  //  width: widget.constraint.screenSize.width * 0.23,
                  height: widget.constraint.screenSize.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blueGrey),
                  child: TextField(
                    mouseCursor: MaterialStateMouseCursor.clickable,
                    //expands: widget.constraint.isTablet ? true : false,
                    controller: searchController,

                    onChanged: (String name) {
                      q = name;
                      if (name == "") {
                        // all working fine but seems some issue wait let me come with another solution
                        setState(() {
                          isSearching = false;
                          print("false");
                        });
                      } else {
                        isSearching = true;
                        print("true");
                        setState(() {});
                      }
                      setState(() {});
                      print("listen");
                      print(isSearching);
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              isSearching = false;
                              q = "";
                              setState(() {});
                              print("close");

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Icon(Icons.close)),
                        hintText: 'search...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none),
                  ),
                ),
                currentFocus.hasPrimaryFocus && isSearching == false
                    ? chatRoomsList()
                    : searchList(), 
              ],
            )));
  }
}

class PopScreen extends StatefulWidget {
  final SizingInformation constraint;
  const PopScreen({Key key, @required this.constraint}) : super(key: key);
  @override
  _PopScreenState createState() => _PopScreenState();
}

class _PopScreenState extends State<PopScreen> {
  final authMethod = Get.find<AuthMethod>();

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(backgroundBlendMode: BlendMode.clear),
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(10),
      margin: widget.constraint.isDesktop
          ? EdgeInsets.fromLTRB(
              20, 10, widget.constraint.screenSize.width * 0.75, 0)
          : EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
            alignment: Alignment.topRight,
            width: 200,
            height: widget.constraint.screenSize.height * 0.112,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    topRight: Radius.zero)),
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    //Get.to(SettingsWeb(constraint: widget.constraint));
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 15),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      )),
                ),
                Divider(
                  color: Colors.black45,
                ),
                GestureDetector(
                  onTap: () {
                    print('tapped');
                    authMethod.signOut();
                    if (widget.constraint.isDesktop) {
                      Get.to(WebPage(
                        constraint: widget.constraint,
                      ));
                    } else {
                      Get.to(TabPage(
                        constraint: widget.constraint,
                      ));
                    }
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 13),
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      )),
                )
              ],
            )),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final SizingInformation constraint;
  ChatRoomsTile(
      {this.userName, @required this.chatRoomId, @required this.constraint});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ConversationScreen(
          chatroomId: chatRoomId,
          constraint: constraint,
        ));
      },
      child: Container(
        //color: Colors.black26,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }
}
