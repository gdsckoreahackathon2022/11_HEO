import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:study/model/ingredient.dart';
import 'package:study/model/list_ingredient.dart';
import 'package:study/screens/home/home_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:study/repository/location_repository.dart';
import 'package:study/screens/add_list/add_list_screen.dart';
import 'package:study/screens/home/home_dialog.dart';
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

  //디데이
  Widget difdate(int expire) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 1, 30, 1),
        child: expire == 0?
        Text('D-Day',style: TextStyle(
                color: expire != 0?
                Colors.black:Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold)):
        Text('D-${expire}',
            style: TextStyle(
                color: expire != 0?
                Colors.black:Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold)));
  }

  //디데이 계산
  int datediffernce(String expire){
    DateTime dateTime1 = DateTime.now();
    //입력한 유통기한
    var dateTime2 =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(expire)));
    //차이계산
    Duration duration = dateTime2.difference(dateTime1);
    var day = duration.inDays+1;

    return day;
  }

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
                      SizedBox(
                        height: 10,
                      ),
                      //캘린더
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
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.bold)),
                          calendarStyle: CalendarStyle(
                            todayTextStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            todayDecoration: BoxDecoration(
                              color: Colors.amberAccent.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: 400,
                          child: Divider(
                              color: Colors.grey.shade300, thickness: 1.0)),
                      
                      //식재료 리스트
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 1, 30, 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Food ingredients',
                                  style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold)),
                              //식재료 추가 버튼
                              MaterialButton(
                                color: Colors.green.shade300,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddListScreen()));
                                },
                                child: Text('addList'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                              ),
                            ]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      //식재료 리스트 나열
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('List')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  int dday = datediffernce(document.get('date'));
                                  ListIngredient listIngredient = ListIngredient(name: document.get('name'), expire: document.get('date'), dday: dday);

                              //리스트 항목 클릭시 다이얼로그
                              return GestureDetector(
                                onTap: (){
                                  Dialog(listIngredient);
                                },
                                child: Container(
                                  height: 75,
                                  margin: EdgeInsets.fromLTRB(25, 3, 25, 10),
                                  padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.lightGreen.shade100),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(listIngredient.name,
                                              style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                  fontSize: 20,)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(listIngredient.expire,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 15,
                                              )),
                                        ],
                                      ),
                                      difdate(listIngredient.dday)
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      )
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

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  // 현재 위치를 주소로 변환
  Future locationCheck() async {
    currentPosition = await _locationRepository.getCurrentLocation();

    // 주소를 받아왔다면 _isLoding => true
    setState(() {
      _isLoding = true;
    });
  }

  //홈 다이얼로그 창
  void Dialog(ListIngredient ingredient) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return HomeDialog(ingredient: ingredient,);
        });
  }
}
