import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study/repository/location_repository.dart';
import 'package:study/screens/add_list/add_list_screen.dart';
import 'package:study/screens/login_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationRepository _locationRepository = LocationRepository();

  // 주소
  late String currentPosition;
  bool _isLoding = false;

  @override
  void initState() {
    super.initState();
    // 위치 권한 확인
    _locationRepository.determinePosition();

    // 비동기를 통해 주소 응답을 기다려줌.
    locationCheck().then((value) async => {});
  }

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
                  logout(context);
                },
              ),
              IconButton(
                  onPressed: () {
                    // 판매 게시글에 현재 사용자의 주소를 보냄.
                    Get.toNamed("post",
                        arguments: {"currentPosition": currentPosition});
                  },
                  icon: Icon(
                    Icons.ac_unit_outlined,
                    size: 30,
                    color: Colors.black,
                  ))
            ]),
        body: _isLoding
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Container(
                        child: TableCalendar(
                          firstDay: DateTime.utc(2010, 10, 20),
                          lastDay: DateTime.utc(2040, 10, 20),
                          focusedDay: DateTime.now(),
                          headerVisible: true,
                          daysOfWeekVisible: true,
                          sixWeekMonthsEnforced: true,
                          shouldFillViewport: false,
                          headerStyle: HeaderStyle(
                              titleTextStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w800)),
                          calendarStyle: CalendarStyle(
                            todayTextStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            todayDecoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: 400,
                          child: Divider(
                              color: Colors.grey.shade300, thickness: 1.0)),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Food ingredients',
                                  style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0))),
                              ),
                            ]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  // 현재 위치를 주소로 변환
  Future locationCheck() async {
    currentPosition = await _locationRepository.getCurrentLocation();

    // 주소를 받아왔다면 _isLoding => true
    setState(() {
      _isLoding = true;
    });
  }
}
