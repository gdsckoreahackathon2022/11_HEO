import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
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

  final _contentsFocusNode = FocusNode();

  final TextEditingController _newNameCon = TextEditingController();
  final TextEditingController _newDescCon = TextEditingController();
  final TextEditingController _newPriceCon = TextEditingController();
  final postId = Get.arguments['docId'].toString();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
  
    if (postId != "null") {
      print(postId);
      _newNameCon.text = Get.arguments["name"].toString();
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

  late ProgressDialog pr;
  UserModel userModel = UserModel();
  List<Asset> images = <Asset>[];

  List<String> loadImage = [];

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context: context);

    return Scaffold(
      appBar: AppBar(
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
            // textColor: Colors.white,
            onPressed: () {
              String errorMsg = "";
              if (_newNameCon.text == "") {
                errorMsg = "제목은 필수 입력 항목입니다.";
                showMsgDialog(errorMsg);
              } else if (_newPriceCon.text == "") {
                errorMsg = "가격은 필수 입력 항목입니다.";
                showMsgDialog(errorMsg);
              } else if (_newDescCon.text == "") {
                errorMsg = "내용은 필수 입력 항목입니다.";
                showMsgDialog(errorMsg);
              } else if (images.length == 0) {
                errorMsg = "사진은 필수 입력 항목입니다.";
                showMsgDialog(errorMsg);
              } else {
                getImage();
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
                TextFormField(
                  controller: _newNameCon,
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
                  onSaved: (value) {},
                ),
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
                  onSaved: (value) {
                    // _editedPost = Post(
                    //   title: _editedPost.title,
                    //   contents: value,
                    //   boardId: _editedPost.boardId,
                    //   datetime: _editedPost.datetime,
                    //   id: _editedPost.id,
                    //   userId: _editedPost.userId,
                    // );
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

  getImage() async {
    FocusManager.instance.primaryFocus?.unfocus();

    for (int i = 0; i < images.length; i++) {
      loadImage.add("a");
      var rnd = Random().nextInt(500) + 1;

      // asset를 File로 변환
      File image = await getImageFileFromAssets(images[i]);

      // storage 이미지 저장
      UploadTask task =
          _fireStorageRepository.uploadImageFile('name', image, rnd);

      task.snapshotEvents.listen((evnt) async {
        print(evnt.bytesTransferred);
        if (evnt.bytesTransferred == evnt.totalBytes) {
          print(1);
          String downlodUrl = await evnt.ref.getDownloadURL();

          loadImage[i] = downlodUrl;
        }
      });
    }

    await uploadImage();

    Get.offAllNamed('/post');
  }

  uploadImage() async {
    pr.show(
      max: 100,
      msg: '업로드 중...',
      progressBgColor: Colors.transparent,
    );
    await Future.delayed(Duration(seconds: 8), () {});

    await _saveForm();
  }

  _saveForm() {
    String uid = CRUDController.to.authUid();
    print("aasdasd${uid}");
    print(postId);

    if (postId == "null") {
      CRUDController.to.createDoc(_newNameCon.text, _newDescCon.text, loadImage,
          _newPriceCon.text, uid);
    } else {
      CRUDController.to.updateDoc(
        postId.toString(),
        _newNameCon.text,
        _newDescCon.text,
        loadImage,
        _newPriceCon.text,
      );
    }
  }
}
