import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matcher/matcher.dart';
import 'package:study/screens/add_list/add_list_screen.dart';
import 'package:study/repository/location_repository.dart';
import 'package:study/screens/home/home_screen.dart';
import 'package:study/screens/post/post_screen.dart';

class tap extends StatefulWidget {
  @override
  _tapState createState() => _tapState();
}

class _tapState extends State<tap> {
  LocationRepository _locationRepository = LocationRepository();
  int _currentindex = 0;
  late String currentPosition;
  List<dynamic> _screen = [
    HomeScreen(),
    AddListScreen(),
    PostScreen()
  ];

  @override
  void initState() {
    super.initState();
    _locationRepository.determinePosition();
    locationCheck().then((value) async => {});
  }

  void _onTap(int index) {
    setState(() {
      if(index<2)
        _currentindex = index;
      else
        Get.toNamed("post",
                        arguments: {"currentPosition": currentPosition});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentindex],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
                backgroundColor: Colors.green.shade300,
            selectedFontSize: 10.0,
            selectedItemColor: Colors.green.shade900,
            unselectedFontSize: 10.0,
            unselectedItemColor: Colors.grey.shade200,
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

  Future locationCheck() async {
    currentPosition = await _locationRepository.getCurrentLocation();
  }
}