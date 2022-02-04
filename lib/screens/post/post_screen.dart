import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:study/controller/location_controller.dart';
import 'package:study/model/post_model.dart';

class PostScreen extends StatefulWidget {
  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (controller) {
      String currentPosition = controller.addr;
      print("주소 : $currentPosition");
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
        ),
        // 새로고침!
        body: RefreshIndicator(
            onRefresh: refreshList,
            color: Colors.green,
            child: _buildBody(context, currentPosition)),

        // 게시물 추가 버튼
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.green.shade300,
            onPressed: () {
              // EditScreen으로 넘어갈 때 postId와 currentPosition을 넘김
              // postId : 게시글 수정하는지 확인하기 위해
              // currentPosition : 어느 위치 게시글에 저장해야하는지 확인하기 위해
              Get.toNamed("/edit", arguments: {
                "postId": "",
                "currentPosition": currentPosition,
                "salesState": "판매중",
              });
            }),
      );
    });
  }

  Widget _buildBody(BuildContext context, currentPosition) {
    // 새로 고침 시에만 리스트를 업데이트 하기 위해 FutureBuilder 사용
    return GetBuilder<LocationController>(builder: (controller) {
      return FutureBuilder(
        // 특정 주소에 게시글만 확인
        future: FirebaseFirestore.instance
            .collection('posts')
            .where("currentPosition", isEqualTo: currentPosition)
            .orderBy('datetime', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(color: Colors.green));
            default:
              return _buildList(context, snapshot.data!.docs, currentPosition);
          }
        },
      );
    });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      String currentPosition) {
    if (snapshot.length == 0) {
      return Center(child: Text("게시글이 없습니다."));
    } else {
      // ListView로 게시글을 하나씩 확인
      return Builder(builder: (context) {
        return ListView(
          children: snapshot.map((DocumentSnapshot document) {
            return _buildListItem(context, document, currentPosition);
          }).toList(),
        );
      });
    }
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, String currentPosition) {
    final currModel = PostModel.fromDocumnet(data);

    int price = int.parse(data['price']); // 가격을 int형을 변환
    String resPrice =
        "${NumberFormat('###,###,###,###').format(price).replaceAll(' ', '')}"; // 가격을 한국 화폐 단위로 변경

    // 날짜
    DateTime currTime = currModel.datetime!.toDate();
    String dt = DateFormat('MM/dd kk:mm').format(currTime);

    // 거래 상태
    String salesState = currModel.salesState.toString();
    // 거래 상태에 따라 투명도 조절
    return Opacity(
      opacity: salesState == "거래완료" ? 0.3 : 1,
      child: Card(
        elevation: 2,
        child: InkWell(
          // 게시글을 눌렀을 때 PostDetailScreen으로 이동
          onTap: () {
            Get.toNamed('/postDetailScreen', arguments: {
              'title': currModel.title,
              'description': currModel.description,
              'imageUrl': currModel.imageUrl,
              'resPrice': price,
              'dt': dt.toString(),
              "uid": currModel.uid,
              "docId": data.id.toString(),
              "currentPosition": currentPosition,
              "salesState": salesState
            });
          },

          onLongPress: () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 게시글의 대표 이미지
                Container(
                  child: Image.network(
                    currModel.imageUrl![0].toString(),
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
                      // 제목
                      Container(
                        child: Text(currModel.title.toString(),
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

                      // 날짜
                      Text(
                        dt.toString(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),

                      SizedBox(
                        height: 5.0,
                      ),
                      // 거래 상태
                      Row(
                        children: [
                          salesState == "거래완료"
                              ? Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius: new BorderRadius.all(
                                            const Radius.circular(
                                                8.0), // 적절히 조절
                                          ),
                                        ),
                                        // color: Colors.grey,
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "거래완료",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                )
                              : Container(),
                          // 가격
                          Text("${resPrice}won",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true)
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // build 업데이트
  Future refreshList() async {
    await Future.delayed(Duration(seconds: 1)); //thread sleep 같은 역할을 함.

    setState(() {
      // build 업데이트
    });
  }

  // 날짜 확인
  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
