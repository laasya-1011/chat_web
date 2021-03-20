import 'package:chat_web/helper/constants.dart';

import 'package:chat_web/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:responsive_builder/responsive_builder.dart';
//import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';

class SettingsWeb extends StatefulWidget {
  final SizingInformation constraint;
  SettingsWeb({@required this.constraint});
  @override
  _SettingsWebState createState() => _SettingsWebState();
}

class _SettingsWebState extends State<SettingsWeb> {
  int index;
  QuerySnapshot snapshot;
  final databaseMethods = Get.put(DatabaseMethods());

  Image image;
  Future getImage() async {
    final _image = await FlutterWebImagePicker.getImage;
    setState(() {
      image = _image;
    });
  }

  getEmailInfo() async {
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      setState(() {
        print('got the data');
        snapshot = val;
      });
    });
    Constants.myEmail = await snapshot.docs[index]['email'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SettingsWeb',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Container(
        width: widget.constraint.screenSize.width,
        height: widget.constraint.screenSize.height,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where("name", isEqualTo: Constants.myName)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView(
                      children: [
                        Center(
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 20),
                                width: widget.constraint.screenSize.width * 0.3,
                                height:
                                    widget.constraint.screenSize.width * 0.3,
                                child: image == null
                                    ? ClipOval(
                                        child: Image.asset(
                                          'assets/profile.png',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipOval(child: image))),
                        GestureDetector(
                          onTap: getImage,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    widget.constraint.screenSize.width * 0.473),
                            width: 10,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                            height: 80,
                            width: widget.constraint.screenSize.width,
                            color: Colors.blue[100],
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 28),
                            child: Row(
                              children: [
                                Text('UserName :',
                                    style: GoogleFonts.raleway(
                                        fontSize: 18, color: Colors.black45)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(snapshot.data.docs[0]['name'],
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black))
                              ],
                            )),
                        Container(
                            width: widget.constraint.screenSize.width,
                            height: 80,
                            color: Colors.blue[100],
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 18),
                            child: Row(
                              children: [
                                Text('Email :',
                                    style: GoogleFonts.raleway(
                                        fontSize: 18, color: Colors.black45)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(snapshot.data.docs[0]['email'],
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black))
                              ],
                            )),
                      ],
                    )
                  : Container();
            }),
      ),
    );
  }
}
