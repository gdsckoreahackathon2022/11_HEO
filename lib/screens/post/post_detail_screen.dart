
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
  CommentScreen _commentScreen = CommentScreen();

  var _isLoading = false;
  final _commentFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentTextEditController = TextEditingController();

  String uid = CRUDController.to.authUid(); // uid
  String email = CRUDController.to.authEmail(); // email
  String postId = Get.arguments["docId"].toString(); // 게시글 id
  String currentPosition = Get.arguments["currentPosition"].toString(); // 주소
  int price = int.parse(Get.arguments["resPrice"].toString()); // 가격

  @override
  void dispose() {
    _commentTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String resPrice =
        "${NumberFormat('###,###,###,###').format(price).replaceAll(' ', '')}"; // 가격을 한국 화폐 단위로 변경

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
                // 게시글 수정 버튼
                // EditScreen으로 입력 정보를 전달
                // 이미지 전달 x: 저장된 이미지는 Url 정보(String 타입)이고 EditScreen에서 보여주는 이미지는 asset 타입이라 따로 이미지는 전달하지 못함.
                // => 하려면 url 정보를 File 타입으로 변환 후 다시 asset 타입으로 변환해야할 듯?
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.offNamed('/edit', arguments: {
                      'title': Get.arguments["title"],
                      'description': Get.arguments["description"],
                      'resPrice': price,
                      "docId": Get.arguments["docId"],
                      "currentPosition": currentPosition
                    });
                  },
                ),
                // 게시글 삭제 버튼
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
                              // 게시글 삭제
                              CRUDController.to
                                  .deleteDoc(postId, currentPosition);

                              // 게시글 삭제 후 PostScreen으로 모든 페이지를 제거 후 이동
                              // 모든 페이지를 제거하지 않고 이동하면 이전 페이지가 stack이 쌓임
                              // 이동 시 주소를 전달
                              Get.offAllNamed("/post", arguments: {
                                "currentPosition": currentPosition
                              });
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
            onRefresh: reFresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,

                      // 아이콘
                      child: CircleAvatar(
                        backgroundColor: Color(0xffE6E6E6),
                        child: Icon(
                          Icons.person,
                          color: Color(0xffCCCCCC),
                        ),
                      ),
                    ),

                    // 이메일
                    title: Text(
                      email,
                      style: TextStyle(fontSize: 14),
                    ),

                    // 날짜
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
                      Get.arguments['title'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.4,
                      textAlign: TextAlign.start,
                    ),
                  ),

                  SizedBox(
                    height: 20,
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
                    height: 20.0,
                  ),
                  Divider(
                    thickness: 1,
                  ),

                  // 댓글
                  Column(children: [
                    _commentScreen.buildBody(context, postId),
                    SizedBox(
                      height: 200.0,
                    )
                  ]),
                ],
              ),
            ),
          ),
        ),
        // 댓글 입력
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
                            hintStyle: TextStyle(color: Colors.black26),
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

  // build 업데이트
  Future reFresh() async {
    await Future.delayed(Duration(seconds: 1)); //thread sleep 같은 역할을 함.
    setState(() {
      // build 업데이트
    });
  }
}
