import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPage extends StatefulWidget {
  const MyPage({ Key? key }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('내정보'),
            onTap: (){
              Get.toNamed("/info");
            }
          ),
          ListTile(
            title: Text('내 글 목록'),
            onTap: (){
              Get.toNamed("/test");
            }
          )
        ],
      ),
      
    );
  }
}