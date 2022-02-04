// import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:study/controller/users_controller.dart';
import 'package:study/screens/test.dart';
import 'package:study/screens/test.dart';

class info extends StatefulWidget {
  const info({Key? key}) : super(key: key);

  @override
  _infoState createState() => _infoState();
}

class _infoState extends State<info> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersController>(builder: (controller) {
      String myNickName = controller.nickName;
      String myPhonNumber = controller.phonNumber;
      String myEmail = authEmail();
      
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Image.asset(
          'assets/logo_img.png',
          width: 90,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.check_circle,
                color: Colors.green.shade800,
                size: 30,
              ),
              onPressed: () {}),
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green,
                    child: Image.asset('assets/icon.png'),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    width: 400,
                    child:
                        Divider(color: Colors.grey.shade300, thickness: 1.0)),
                
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text('판매 내역',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ],
                ),
                Center(
                  child: MaterialButton(
                    minWidth: 100,
                    height: 40,
                    color: Colors.green.shade600,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestScreen()));
                    },
                    child: Text('나의 판매 내역 보기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                ),const SizedBox(
                  height: 10,
                ),
                Container(
                    width: 400,
                    child:
                        Divider(color: Colors.grey.shade300, thickness: 1.0)),
                //내 정보
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text('내 정보',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ],
                ),const SizedBox(
                  height: 5,
                ),
                //닉네임
                Container(
                  width: 600,
                  height: 70,
                  margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen.shade100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nickname'),
                      Text( myNickName, 
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                //이메일
                Container(
                  width: 600,
                  height: 70,
                  margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen.shade100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email'),
                      Text(myEmail, 
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                //전화번호
                Container(
                  width: 600,
                  height: 70,
                  margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen.shade100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phone'),
                      Text( myPhonNumber, 
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );});
  }
}

String email = '';

FirebaseAuth auth = FirebaseAuth.instance;

// 유저 정보 가져오기
String authUid() {
  return auth.currentUser!.uid;
}

// 유저 이메일 가져오기
String authEmail() {
  return auth.currentUser!.email.toString();
}

String authphone() {
  return auth.currentUser.toString();
}

void readData() {
  final userCollectionReference =
      FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid);
  userCollectionReference.get().then((value) {
    print(value.data());
  });
}