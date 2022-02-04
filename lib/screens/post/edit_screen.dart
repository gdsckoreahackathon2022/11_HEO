import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:study/controller/bottom_navigation_page_controller.dart';
import 'package:study/controller/crud_controller.dart';
import 'package:study/controller/image_crop_controller.dart';
import 'package:study/model/user_model.dart';
import 'package:study/repository/firestorage_repository.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  FireStorageRepository _fireStorageRepository = FireStorageRepository();
  BottomNavigationPageController _bottomNavigationPageController =
      Get.put(BottomNavigationPageController());

  @override
  void initState() {
    super.initState();
    if(Get.arguments["name"] != null)
      _newTitleCon.text = Get.arguments["name"];
  }

  @override
  void didChangeDependencies() {
    // postId가 not null이라면 => 게시글 작성자라면
    if (postId != "null") {
      print("게시글 작성자 : $postId");
      _newTitleCon.text = Get.arguments["title"].toString();
      _newDescCon.text = Get.arguments["description"].toString();
      _newPriceCon.text = Get.arguments["resPrice"].toString();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contentsFocusNode.dispose();
    super.dispose();
  }

  final _contentsFocusNode = FocusNode();
  final TextEditingController _newTitleCon = TextEditingController();
  final TextEditingController _newDescCon = TextEditingController();
  final TextEditingController _newPriceCon = TextEditingController();

  late ProgressDialog pr;
  UserModel userModel = UserModel();
  List<Asset> images =
      <Asset>[]; // multi_image_picker2를 통해 여러 사진을 asset 타입으로 저장
  List<String> loadImage = []; // 이미지를 Url로 변환하여 String 타입으로 저장
  final String currentPosition = Get.arguments["currentPosition"]; // 주소
  final String postId = Get.arguments['docId'].toString();
  final String salesState = Get.arguments['docId'].toString();

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context: context); // sn_progress_dialog

    print("주소 : ${currentPosition}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,

        // 게시글 작성자인지 판단
        title: postId != "null"
            ? Text(
                '이웃거래 글 수정하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            : Text(
                '이웃거래 글쓰기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Get.back();
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "완료",
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(
                fontSize: 14,
              ),
            ),
            onPressed: () {
              // 필수 입력 항목을 작성해야 한다는 msg를 보냄.
              String errorMsg = "";

              if (_newTitleCon.text == "") {
                errorMsg = "제목은 필수 입력 항목입니다.";
              } else if (_newPriceCon.text == "") {
                errorMsg = "가격은 필수 입력 항목입니다.";
              } else if (_newDescCon.text == "") {
                errorMsg = "내용은 필수 입력 항목입니다.";
              } else if (images.length == 0) {
                errorMsg = "사진은 필수 입력 항목입니다.";
              }

              // 필수 입력 항목을 모두 작성했다면 getImage() 실행
              if (errorMsg == "") {
                getImage();

                // 필수 입력 항목을 작성하지 않았다면 dialog 실행
              } else {
                showMsgDialog(errorMsg);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 100.0,
                  // width: MediaQuery.of(context).size.width,
                  child: buildGridView(),
                ),

                // 제목
                TextFormField(
                  controller: _newTitleCon,
                  decoration: InputDecoration(
                    labelText: '제목',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_contentsFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),

                // 가격
                TextFormField(
                  controller: _newPriceCon,
                  decoration: InputDecoration(
                    labelText: '가격',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_contentsFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null;
                  },
                ),

                // 내용
                TextFormField(
                  controller: _newDescCon,
                  decoration: InputDecoration(labelText: '내용'),
                  maxLines: 15,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  focusNode: _contentsFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '내용을 입력해주세요.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return GestureDetector(
                onTap: () async {
                  List<Asset> resultList =
                      await ImageCropController.to.seletctImage(images);

                  setState(() {
                    images = resultList;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  width: 100.0,
                  child: Icon(Icons.camera_alt_outlined),
                ),
              );
            }

            Asset asset = images[index - 1];

            return Container(
              child: AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
              padding: EdgeInsets.all(5.0),
            );
          }),
    );
  }

  getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  // 에러 메시지 사용자에게 알림
  void showMsgDialog(String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 100,
            child: Center(
              child: Text(msg),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("ok"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  // 이미지를 sotrage에 저장 후 Url를 가져옴
  getImage() async {
    FocusManager.instance.primaryFocus?.unfocus();

    // 반복문을 통해 모든 사진을 확인
    for (int i = 0; i < images.length; i++) {
      loadImage.add("a");
      var rnd = Random().nextInt(500) + 1;

      // asset 타입을 File 타입으로 변환
      File image = await getImageFileFromAssets(images[i]);

      // storage 이미지 저장
      UploadTask task =
          _fireStorageRepository.uploadImageFile('title', image, rnd);

      // storage에 저장된 이미지의 Url를 가져옴
      task.snapshotEvents.listen((evnt) async {
        print(evnt.bytesTransferred);
        if (evnt.bytesTransferred == evnt.totalBytes) {
          String downlodUrl = await evnt.ref.getDownloadURL();

          loadImage[i] = downlodUrl; // Url를 loadImage에 저장
        }
      });
    }

    await uploadImage();

    // 게시글 삭제 후 PostScreen으로 모든 페이지를 제거 후 이동
    // 모든 페이지를 제거하지 않고 이동하면 이전 페이지가 stack이 쌓임
    _bottomNavigationPageController.changePage(1);
    Get.offAllNamed('/tap');
  }

  // 이미지를 저장하고 Url를 가져오는데 시간이 오래 걸려서 딜레이를 시킴
  uploadImage() async {
    // sn_progress_dialog show
    pr.show(
      max: 100,
      msg: '업로드 중...',
      progressBgColor: Colors.transparent,
    );
    // 최대 5개 사진을 저장할 때 8초정도 걸림.
    // 다른 방법을 고민중..
    await Future.delayed(Duration(seconds: 8), () {});

    await _saveForm();
  }

  // 게시글 저장
  _saveForm() {
    String uid = CRUDController.to.authUid();
    print("게시글 작성자 : $postId");

    // 게시글이 create인지 update인지 확인 후 실행
    if (postId == "null") {
      CRUDController.to.createDoc(_newTitleCon.text, _newDescCon.text,
          loadImage, _newPriceCon.text, uid, currentPosition, salesState);
    } else {
      CRUDController.to.updateDoc(postId.toString(), _newTitleCon.text,
          _newDescCon.text, loadImage, _newPriceCon.text);
    }
  }
}
