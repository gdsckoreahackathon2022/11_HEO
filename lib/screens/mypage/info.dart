// import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:study/controller/users_controller.dart';

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

      print(myNickName);
      print(myPhonNumber);
      print(myEmail);

      return Scaffold(
        appBar: AppBar(
          title: const Text("내 정보"),
        ),
        body: Container(
          padding: EdgeInsets.all(50),
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
                height: 100,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Text("NickName : " + myNickName, style: _style),
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Text("Email : " + myEmail, style: _style),
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Text('Phone : ' + myPhonNumber, style: _style),
              ),
              ElevatedButton(
                  onPressed: () {
                    readData();
                  },
                  child: Text("정보 가져오기"))
            ],
          ),
        ),
      );
    });
  }

  final TextStyle _style = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 20,
      letterSpacing: 2.0);
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
