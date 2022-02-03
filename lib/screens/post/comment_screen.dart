import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:study/controller/crud_controller.dart';
import 'package:study/model/comment_model.dart';

class CommentScreen {
  Widget buildBody(BuildContext context, String postid) {
    // StreamBuilder를 통해 댓글 내용을 계속해서 업데이트
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .doc(postid)
          .collection("comment")
          .orderBy('datetime', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text("Error: ${snapshot.error}");
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(
              color: Colors.green,
            ));
          default:
            return _buildList(context, snapshot.data!.docs, postid);
        }
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot, postid) {
    // 댓글이 없으면
    if (snapshot.length == 0) {
      return Column(children: [
        SizedBox(
          height: 10,
        ),
        Text("댓글이 없습니다."),
      ]);
      
      // 댓글이 있으면
    } else {
      return Column(
        children: snapshot.map((DocumentSnapshot document) {
          return _buildListItem(context, document, postid);
        }).toList(),
      );
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data, postid) {
    final currModel = CommentModel.fromDocumnet(data);

     // 날짜
    DateTime currTime = currModel.datetime!.toDate(); 
    String dt = DateFormat('MM/dd kk:mm').format(currTime);

    // 현재 유저 정보
    String authUid = CRUDController.to.authUid(); 

    print("현재 유저 정보 : ${authUid}");
    print("댓글 작성자 정보 : ${currModel.uid}");
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              child: Icon(
                Icons.comment,
                color: Color(0xffCCCCCC),
              ),
            ),
          ),

          // 이름
          title: Text(
            currModel.name.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                currModel.comment.toString(),
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                dt.toString(),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),

          // 유저 정보와 댓글 작성자 정보가 같으면 삭제 버튼 생성
          trailing: currModel.uid == authUid
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('삭제'),
                        content: Text(
                          '선택한 댓글을 삭제할까요?',
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              '확인',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              // 댓글 삭제
                              CRUDController.to.deleteComment(postid, data.id);
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                )
              : null,
        ),
        Divider(
          thickness: 1,
        ),
      ],
    );
  }

  // 날짜 정보
  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
