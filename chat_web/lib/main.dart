import 'package:chat_web/helper/helperFunc.dart';
import 'package:chat_web/services/auth.dart';
import 'package:chat_web/services/database.dart';
//import 'package:chat_web/views/mobile/MobilePage.dart';
//import 'package:chat_web/views/mobile/mobilechat.dart';
import 'package:chat_web/views/tablet/TabPage.dart';
//import 'package:chat_web/views/tablet/tabchat.dart';
import 'package:chat_web/views/webpage/WebPage.dart';
import 'package:chat_web/views/webpage/chatroom.dart';
import 'package:chat_web/views/webpage/webchat.dart';
//import 'package:chat_web/views/webpage/webchat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'web_chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool userLoggedIn = false;
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedIn().then((val) {
      setState(() {
        userLoggedIn = val;
      });
    });
  }

  final authMethod = Get.put(AuthMethod());
  final databasemethods = Get.put(DatabaseMethods());
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, constraints) {
        if (constraints.isDesktop) {
          return userLoggedIn != null
              ? WebChat(
                  constraint: constraints,
                )
              : WebPage(
                  constraint: constraints,
                );
        } else {
          return userLoggedIn != null
              ? ChatRoom(constraint: constraints)
              : TabPage(
                  constraint: constraints,
                );
        }
      },
    );
  }
}
