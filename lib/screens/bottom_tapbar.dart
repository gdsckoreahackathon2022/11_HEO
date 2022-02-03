import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matcher/matcher.dart';
import 'package:study/screens/add_list/add_list_screen.dart';
import 'package:study/screens/home/home_screen.dart';
import 'package:study/screens/post/post_screen.dart';

class tap extends StatefulWidget {
  @override
  _tapState createState() => _tapState();
}

class _tapState extends State<tap> {
  int _currentindex = 0;
  final List<Widget> _screen = [
    HomeScreen(),
    AddListScreen(),
    PostScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentindex],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
                backgroundColor: Colors.green.shade200,
            selectedFontSize: 10.0,
            selectedItemColor: Color(0xff54767a),
            unselectedFontSize: 10.0,
            unselectedItemColor: Color(0xffbac9cb),
            type: BottomNavigationBarType.fixed,
            elevation: 5.0,
            onTap: _onTap,
            currentIndex: _currentindex,
            items: [
              new BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: ("Home"),
              ),
              new BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  size: 30,
                ),
                label: ("diary"),
              ),
              new BottomNavigationBarItem(
                icon: Icon(
                  Icons.medical_services_rounded,
                  size: 30,
                ),
                label: ("medicine"),
              ),
              
            ]),
      ),
    );
  }
}