import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:study/controller/crud_controller.dart';
import 'package:study/model/comment_model.dart';

class CommentScreen {
  Widget buildBody(BuildContext context, String postid) {
    // 새로 고침 시에만 리스트를 업데이트 하기 위해 FutureBuilder 사용
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
            return Center(child: CircularProgressIndicator());
          default:
            return _buildList(context, snapshot.data!.docs, postid);
        }
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot, postid) {
    print(11);
    if (snapshot.length == 0) {
      return Column(children: [
        SizedBox(
          height: 10,
        ),
        Text("댓글이 없습니다."),
      ]);
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

    DateTime currTime = currModel.datetime!.toDate();
    String dt = DateFormat('MM/dd kk:mm').format(currTime);

    String auth_uid = CRUDController.to.authUid();
    print("cccccccccccc${auth_uid}");

    print("cccccccc${data.id}");
    print("cccbbbbb${currModel.uid}");
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
          trailing: currModel.uid == auth_uid
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
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              '확인',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              print("${data.id}");
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

    // Card(
    //   elevation: 2,
    //   child: InkWell(
    //     // Read Document
    //     onTap: () {},

    //     onLongPress: () {},
    //     child: Container(
    //       padding: const EdgeInsets.all(8),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Padding(
    //             padding: EdgeInsets.all(8),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Container(
    //                   width: MediaQuery.of(context).size.width * 0.6,
    //                   child: Text(currModel.name.toString(),
    //                       style: TextStyle(
    //                         color: Colors.blueGrey,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                       // overflow: TextOverflow.ellipsis,
    //                       softWrap: true),
    //                 ),
    //                 SizedBox(
    //                   height: 5.0,
    //                 ),
    //                 Container(
    //                   width: MediaQuery.of(context).size.width * 0.6,
    //                   child: Text(currModel.comment.toString(),
    //                       style: TextStyle(
    //                         color: Colors.grey,

    //                       ),
    //                       // overflow: TextOverflow.ellipsis,
    //                       softWrap: true),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Text(
    //             dt.toString(),
    //             style: TextStyle(color: Colors.grey[600]),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
