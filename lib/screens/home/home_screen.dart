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
import 'package:study/screens/home/show_list.dart';
import 'package:study/screens/login_screen.dart';
import 'package:study/screens/mypage/info.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoding = true;
  final GlobalKey<AnimatedListState> key = GlobalKey();
  List<ListIngredient> products = [];

  //디데이
  Widget difdate(int expire) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 1, 30, 1),
        child: expire == 0
            ? Text('D-Day',
                style: TextStyle(
                    color: expire != 0 ? Colors.black : Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
            : Text('D-$expire',
                style: TextStyle(
                    color: expire != 0 ? Colors.black : Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)));
  }

  //디데이 계산
  int datediffernce(String expire) {
    DateTime dateTime1 = DateTime.now();
    //입력한 유통기한
    var dateTime2 =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(expire)));
    //차이계산
    Duration duration = dateTime2.difference(dateTime1);
    var day = duration.inDays;

    print(dateTime1);

    return day;
  }

  @override
  void initState() {
    super.initState();
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
                            .collection('Lists')
                            .doc(auth.currentUser!.uid)
                            .collection('ingredient')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          final datas = snapshot.data!.docs;
                          return AnimatedList(
                              physics: NeverScrollableScrollPhysics(),
                              key: key,
                              shrinkWrap: true,
                              initialItemCount: datas.length,
                              itemBuilder: (context, index, animation) {
                                print(datas[index].get('date'));
                                var dday =
                                    datediffernce(datas[index].get('date'));
                                var data = ListIngredient(
                                    name: datas[index].get('name'),
                                    expire: datas[index].get('date'),
                                    dday: dday);
                                products.add(data);
                                ListIngredient ingredient = ListIngredient(
                                    name: data.name,
                                    expire: data.expire,
                                    dday: data.dday);
                                return ShowList(
                                    ingredient: ingredient,
                                    animation: animation,
                                    onClicked: () => removeItem(index));
                              });
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

  //홈 다이얼로그 창
  void Dialog(ListIngredient ingredient) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return HomeDialog(
            ingredient: ingredient,
          );
        });
  }

  //리스트에서 아이템 제거
  //제거 후 리스트가 비어있다면 텍스트 출력
  removeItem(int index) {
    final removedItem = products[index];
    getInfo(index);

    products.removeAt(index);
    key.currentState!.removeItem(
        index,
        (context, animation) => ShowList(
            ingredient: removedItem, animation: animation, onClicked: () {}),
        duration: Duration(milliseconds: 400));
    print('removed');
  }

  getInfo(int index) async {
    var a = FirebaseFirestore.instance
        .collection('Lists')
        .doc(auth.currentUser!.uid)
        .collection('ingredient')
        .where("name", isEqualTo: products[index].name)
        .where("date", isEqualTo: products[index].expire);

    var b = await a.get();
    var c = b.docs[0].reference;
    print('>>>>>$c');
    print(c.id);

    return FirebaseFirestore.instance
        .collection("Lists")
        .doc(auth.currentUser!.uid)
        .collection("ingredient")
        .doc(c.id)
        .delete();
  }
}
