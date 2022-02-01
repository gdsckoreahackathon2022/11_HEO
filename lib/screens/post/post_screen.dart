import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:study/controller/crud_controller.dart';
import 'package:study/model/post_model.dart';

class PostScreen extends StatefulWidget {
  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();
  // TextEditingController _undGpsCon = TextEditingController();

  // 아직 디자인적인 요소와 build 업데이트 빼면 쓸모없음..
  Future refreshList() async {
    // 음.. 위치 확인을 할 때?..
    await Future.delayed(Duration(seconds: 1)); //thread sleep 같은 역할을 함.

    setState(() {
      // build 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // textfield overflow xxxxxxxx
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
          title: Image.asset(
            'assets/logo_img.png',
            width: 90,
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
      ),
      body: RefreshIndicator(
          // StreamBuilder를 이용해서 text 컬렉션을 바인딩학고 document를 ListView로 UI에 뿌려주게 된다.
          onRefresh: refreshList,
          child: _buildBody(context)),
      // Create Document
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.green.shade300,
          onPressed: () {
            Get.toNamed("/edit", arguments: {
              "postId": "",
            });
          }),
    );
  }

  Widget _buildBody(BuildContext context) {
    // 새로 고침 시에만 리스트를 업데이트 하기 위해 FutureBuilder 사용
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('post')
          .orderBy('datetime', descending: true)
          .get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text("Error: ${snapshot.error}");
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());

          default:
            return _buildList(context, snapshot.data!.docs);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.length == 0) {
      return Center(
        child: Text("게시글이 없습니다."), // 더 멋진 디자인으로..
      );
    } else {
      return ListView(
        children: snapshot.map((DocumentSnapshot document) {
          // 좌표(나중에 사용)
          // GeoPoint gps = document[fnGps];
          // print(gps.latitude);
          // print(gps.longitude);

          return _buildListItem(context, document);
        }).toList(),
      );
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final currModel = PostModel.fromDocumnet(data);

    int price = int.parse(data['price']);
    String resPrice =
        "${NumberFormat('###,###,###,###').format(price).replaceAll(' ', '')}";

    DateTime currTime = currModel.datetime!.toDate();
    String dt = DateFormat('MM/dd kk:mm').format(currTime);

    // 날짜 나오게 하는 다른 방법.
    // Timestamp ts = data[fnDatetime];
    // String dt = timestampToStrDateTime(ts);

    print("ccc${data.id}");
    return Card(
      elevation: 2,
      child: InkWell(
        // Read Document
        onTap: () {
          Get.toNamed('/postDetailScreen', arguments: {
            'name': currModel.name,
            'description': currModel.description,
            'imageUrl': currModel.imageUrl,
            'resPrice': price,
            'dt': dt.toString(),
            "uid": currModel.uid,
            "docId": data.id.toString()
          });
        },

        
        onLongPress: () {},
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Image.network(
                  data["imageUrl"][0],
                  fit: BoxFit.cover,
                ),
                height: 120.0,
                width: 120.0,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(data['name'],
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          // overflow: TextOverflow.ellipsis,
                          softWrap: true),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      dt.toString(),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("${resPrice}원",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        // overflow: TextOverflow.ellipsis,
                        softWrap: true),
                
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
