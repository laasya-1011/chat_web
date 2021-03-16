import 'package:chat_web/views/webpage/chatroom.dart';
import 'package:chat_web/views/webpage/webchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_web/helper/helperFunc.dart';
import 'package:chat_web/services/auth.dart';
import 'package:chat_web/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RightSideWidget extends StatefulWidget {
  final SizingInformation sizeInfo;
  const RightSideWidget({Key key, this.sizeInfo}) : super(key: key);

  @override
  _RightSideWidgetState createState() => _RightSideWidgetState();
}

class _RightSideWidgetState extends State<RightSideWidget> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final formKey = GlobalKey<FormState>();
  bool isLoginPage = true;
  bool isLoading = false;
  final authMethod = Get.find<AuthMethod>();
  final databaseMethods = Get.find<DatabaseMethods>();
  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'name': _nameController.text,
        'email': _emailController.text
      };
      HelperFunctions.saveUserName(_nameController.text);
      HelperFunctions.saveUserEmail(_emailController.text);
      setState(() {
        isLoading = true;
      });

      authMethod
          .signUpWithEmailandPassword(
              _emailController.text, _passwordController.text)
          .then((val) {
        // print('$val');
        if (val != null) {
          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedIn(true);
          Get.to(WebChat(constraint: widget.sizeInfo));
        }
      }).catchError((e) {
        print(e.toString());
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  QuerySnapshot snapshotUserInfo;
  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmail(_emailController.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(_emailController.text).then((val) {
        setState(() {
          snapshotUserInfo = val;
        });

        HelperFunctions.saveUserName(snapshotUserInfo.docs[0]['name']);
      });
      authMethod
          .signInWithEmailandPassword(
              _emailController.text, _passwordController.text)
          .then((val) {
        // print('$val');

        if (val != null) {
          HelperFunctions.saveUserLoggedIn(true);
          if (widget.sizeInfo.isDesktop) {
            Get.to(WebChat(constraint: widget.sizeInfo));
          } else {
            Get.to(ChatRoom(
              constraint: widget.sizeInfo,
            ));
          }
        }
      }).catchError((e) {
        print(e.toString());
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    cnt++;
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  var cnt = 0;
  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: double.infinity,
            //width: widget.sizeInfo.screenSize.width,
            child: cnt < 2 ? _bodyWidget() : _loadingWidget(),
          );
  }

  Widget _loadingWidget() {
    return Container(
      width: widget.sizeInfo.screenSize.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageWidget(),
          SizedBox(
            height: 15,
          ),
          _fromWidget(),
          SizedBox(
            height: 15,
          ),
          _buttonWidget(),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _rowTextWidget(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Lottie.asset("assets/loading.json"),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Container(
      width: widget.sizeInfo.screenSize.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageWidget(),
          SizedBox(
            height: 15,
          ),
          _fromWidget(),
          SizedBox(
            height: 15,
          ),
          _buttonWidget(),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _rowTextWidget(),
          ),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
              image: AssetImage("assets/profile.png"), fit: BoxFit.fill)),
    );
  }

  Widget _fromWidget() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          isLoginPage == true
              ? Text('')
              : Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                  child: TextFormField(
                    validator: (val) {
                      return val.length > 2
                          ? null
                          : '       Please provide a valid username';
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "User Name",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: TextFormField(
              validator: (val) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)
                    ? null
                    : '       Please provide a valid emailID';
              },
              controller: _emailController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Email Address",
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: TextFormField(
              validator: (val) {
                return val.length > 7
                    ? null
                    : '       minimum 8 characters needed ';
              },
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonWidget() {
    return InkWell(
      onTap: () {
        isLoginPage == true ? signIn() : signMeUp();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: widget.sizeInfo.screenSize.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Text(
          isLoginPage == true ? "LOGIN" : "REGISTER",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _rowTextWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLoginPage == true ? "Don't have account?" : "Have an account?",
          style: TextStyle(fontSize: 16, color: Colors.indigo[400]),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (isLoginPage == true)
                isLoginPage = false;
              else
                isLoginPage = true;
            });
          },
          child: Text(
            isLoginPage == true ? " Sign Up" : " Sign In",
            style: TextStyle(
                fontSize: 16,
                color: Colors.indigo,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
