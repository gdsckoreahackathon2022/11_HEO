import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:study/controller/crud_controller.dart';

import 'comment_screen.dart';

class PostDetailScreen extends StatefulWidget {
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  var _isLoading = false;
  final _commentFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentTextEditController = TextEditingController();
  CommentScreen _commentScreen = CommentScreen();

  // Future<void> _refreshPosts(
  //     BuildContext context, String boardId, String postId) async {
  //   await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(boardId);
  //   await Provider.of<Comments>(context, listen: false)
  //       .fetchAndSetComments(postId);
  // }

  Future a() async {
    await Future.delayed(Duration(seconds: 1)); //thread sleep 같은 역할을 함.
  }

  @override
  void dispose() {
    _commentTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String uid = CRUDController.to.authUid();
    String email = CRUDController.to.authEmail();
    String postId = Get.arguments["docId"].toString();
    print(postId);

    print(Get.arguments["uid"]);

    int price = int.parse(Get.arguments["resPrice"].toString());

    String resPrice =
        "${NumberFormat('###,###,###,###').format(price).replaceAll(' ', '')}";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "식자재 설명",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        elevation: 0.0,

        // 글쓴이가 자기 자신이면 수정, 삭제 버튼 활성
        actions: uid == Get.arguments["uid"]
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.offNamed('/edit', arguments: {
                      'name': Get.arguments["name"],
                      'description': Get.arguments["description"],
                      'imageUrl': Get.arguments["imageUrl"],
                      'resPrice': price,
                      "docId": Get.arguments["docId"],
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('삭제'),
                        content: Text(
                          '게시글을 삭제할까요?',
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
                              print(postId);
                              CRUDController.to.deleteDoc(postId);
                              Get.toNamed("/post");
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Stack(children: [
        GestureDetector(
          onTap: () {
            _commentFocusNode.unfocus();
          },
          child: RefreshIndicator(
            // onRefresh: () => _refreshPosts(context, post.boardId!, id),
            onRefresh: a,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  // 아이콘, 익명, datetime
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffE6E6E6),
                        child: Icon(
                          Icons.person,
                          color: Color(0xffCCCCCC),
                        ),
                      ),
                    ),
                    title: Text(
                      email,
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      Get.arguments['dt'].toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  // 이미지
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Swiper(
                          control: SwiperControl(),
                          pagination: SwiperPagination(),
                          itemCount: Get.arguments['imageUrl'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              Get.arguments['imageUrl'][index].toString(),
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )),

                  // 가격
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(
                      "${resPrice.toString()}원",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textScaleFactor: 1.4,
                      textAlign: TextAlign.start,
                    ),
                  ),

                  // 제목
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(
                      Get.arguments['name'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.4,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  // 내용
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        Get.arguments['description'].toString(),
                        // "ter",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  // 댓글 목록
                  // comments.isEmpty
                  //     ?
                  Column(children: [
                    _commentScreen.buildBody(context, postId),
                    SizedBox(height: 200.0,)
                  ]),

                  // : Column(
                  //     children: [
                  //       Column(

                  //           children: comments
                  //               .map((comment) => CommentItem(comment.id))
                  //               .toList()),
                  //       SizedBox(
                  //         height: 100,
                  //       )
                  //     ],
                  //   )
                ],
              ),
            ),
          ),
        ),
        Align(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          focusNode: _commentFocusNode,
                          controller: _commentTextEditController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return '댓글을 입력하세요.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            hintText: "댓글을 입력하세요.",
                            hintStyle: new TextStyle(color: Colors.black26),
                            suffixIcon: _isLoading
                                ? CircularProgressIndicator()
                                : IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      String commentText =
                                          _commentTextEditController.text;
                                      print('input comment: ' +
                                          _commentTextEditController.text);

                                      if (_formKey.currentState!.validate()) {
                                        CRUDController.to.createComment(
                                            commentText, uid, email, postId);

                                        _commentTextEditController.clear();
                                        _commentFocusNode.unfocus();
                                      } else {
                                        null;
                                      }
                                    },
                                  ),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          alignment: Alignment.bottomCenter,
        ),
      ]),
    );
  }

  // Future<void> _addComment(
  //     String boardId, String postId, String contents) async {
  //   final comment = Comment(
  //       contents: contents,
  //       postId: postId,
  //       userId: null,
  //       datetime: null,
  //       id: null);
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await Provider.of<Comments>(context, listen: false).addComment(comment);
  //   _refreshPosts(context, boardId, postId);
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // Future<void> _addNotification(String postTitle, String contents,
  //     String postId, String receiverId) async {
  //   final notification = noti.Notification(
  //     title: "새로운 댓글: " + postTitle,
  //     contents: contents,
  //     datetime: null,
  //     id: null,
  //     postId: postId,
  //     receiverId: receiverId,
  //   );
  //   await Provider.of<Notifications>(context, listen: false)
  //       .addNotification(notification);
  // }
}
