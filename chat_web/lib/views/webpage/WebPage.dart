import 'package:chat_web/views/webpage/widgets/left_side_widget.dart';
import 'package:chat_web/views/webpage/widgets/right_side_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WebPage extends StatelessWidget {
  final SizingInformation constraint;
  const WebPage({Key key,@required this.constraint}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: constraint.screenSize.width,
        height: double.infinity,
        //color: Colors.pink,
        child: Row(
          children: [
            LeftSideWidget(
              sizeInfo: constraint,
            ),
            Expanded(
              child: RightSideWidget(
                sizeInfo: constraint,
              ),
            )
          ],
        ),
      ),
    );
  }
}
