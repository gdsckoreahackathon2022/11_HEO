import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study/screens/add_list/add_list_screen.dart';
import 'package:study/screens/login_screen.dart';
import 'package:study/screens/post/post_screen.dart';
//필요없는 창이라 다 구현X

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Image.asset(
            'assets/logo_img.png',
            width: 90,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app_outlined,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {
                LoginScreen();
              },
            )
          ]),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
          color: Colors.green.shade300,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddListScreen()));
                  },
                  child: Text('addList'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0)
                    )
                  ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),

              // 판매 게시글 목록 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostScreen()),
                  );
                },
                child: Text('PostScrren'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
