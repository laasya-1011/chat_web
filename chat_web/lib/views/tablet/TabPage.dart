import 'package:chat_web/views/webpage/widgets/right_side_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
//import 'package:responsive_builder/responsive_builder.dart';

class TabPage extends StatefulWidget {
  final SizingInformation constraint;
  TabPage({this.constraint});
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RightSideWidget(
          sizeInfo: widget.constraint,
        ),
      ),
    );
  }
}
