import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:lottie/lottie.dart';

class LeftSideWidget extends StatelessWidget {
  final SizingInformation sizeInfo;
  const LeftSideWidget({Key key, this.sizeInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeInfo.screenSize.width * 0.65,
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.indigo[400], Colors.blue[300]])),
      height: double.infinity,
      child: Container(
        child: Stack(
          children: [
            _loginButton(),
            _bgImageWidget(),
            _welcomeTextWidget(),
            Positioned(
                left: -130,
                bottom: -130,
                child: Image.asset(
                  "assets/shape.png",
                  color: Colors.white.withOpacity(.2),
                ))
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(''),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white60, width: 1.5),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            'LOGIN',
            style: TextStyle(color: Colors.white60, fontSize: 17),
          ),
        )
      ],
    );
  }

  _bgImageWidget() {
    return Align(
      alignment: Alignment.topCenter,
      child: Lottie.asset("assets/img.json"),
    );
  }

  Widget _welcomeTextWidget() {
    return Positioned(
      left: 75,
      bottom: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WELCOME TO WebChat".toUpperCase(),
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: sizeInfo.screenSize.width * 0.60,
            child: Text(
              "Flutter is Google\’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase\.",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: Colors.white60, width: 1.50),
              ),
              child: Text(
                "SIGN IN",
                style: TextStyle(fontSize: 16, color: Colors.white60),
              )),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
