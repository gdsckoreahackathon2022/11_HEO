import 'package:flutter/material.dart';
import 'package:study/model/list_item.dart';
import 'package:study/screens/add_list/list_item_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study/screens/add_list/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddListScreen extends StatefulWidget {
  const AddListScreen({Key? key}) : super(key: key);

  @override
  _AddListScreenState createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen> {
  List<ListItem> products = [];
  TextEditingController textController = new TextEditingController();
  Widget view = Center(
      child: Text('상품을 등록해주세요!',
          style: TextStyle(color: Colors.grey, fontSize: 20)));
  final GlobalKey<AnimatedListState> key = GlobalKey();
  bool tf = true;
  String today = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
          title: Image.asset(
            'assets/logo_img.png',
            width: 90,
          ),
          centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                if (products.length > 0) {
                  for (int i = 0; i < products.length; i++) {
                    add2Firebase(products[i]);
                  }
                  Fluttertoast.showToast(
                      msg: "상품 등록이 완료되었습니다",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.grey[600],
                      textColor: Colors.white,
                      fontSize: 16.0);
                  setState(() {
                    products.clear();
                    view = Center(
                        child: Text('상품을 추가해주세요!',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 20)));
                  });
                  tf = !tf;
                }
              },
              child: Text('등록'))
        ],
      ),
      //애니메이션이 들어간 리스트
      body: view,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.photo_library_outlined, color: Colors.white,),
              backgroundColor: Colors.green.shade300,
              heroTag: 'auto',
              onPressed: getImage),
            SizedBox(height: 20),
            FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white,),
              backgroundColor: Colors.blue.shade300,
              heroTag: 'manual',
              onPressed: () {
              if (tf) {
                setState(() {
                  view = AnimatedList(
                      key: key,
                      initialItemCount: products.length,
                      itemBuilder: (context, index, animation) =>
                          listItemWidget(
                              item: products[index],
                              animation: animation,
                              onClicked: () => removeItem(index)));
                  tf = false;
                });
              }
              makeTile();
            })
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  //갤러리에서 이미지를 불러온 후 ocr처리
  Future getImage() async {
    ImagePicker picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);

    /*
      tesseract를 통해 영수증 이미지에서 텍스트 추출(인식 언어는 한국어+영어)
      psm 값은 4,6,11이 한국어 인식 가능 번호
      4: 가변적인 크기의 1라인 텍스트
      6: 텍스트의 균일한 단일 블록을 가정
      11: 특정 순서없이 가능한 많은 찾기
    */
    if (image != null) {
      String text = await FlutterTesseractOcr.extractText('${image.path}',
          language: 'kor+eng',
          args: {
            "psm": "4",
            "preserve_interword_spaces": "1", //단어 간격 옵션 조절
          });
      print(text);
    }
  }

  //오늘 날짜 불러오기
  getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    today = formatter.format(now);
  }

  add2Firebase(ListItem item) {
    FirebaseFirestore.instance
        .collection('List')
        .add({'user': auth.currentUser!.uid, 'name': '${item.name}', 'date': '${item.date}'});
  }

  //리스트에서 아이템 제거
  //제거 후 리스트가 비어있다면 텍스트 출력
  removeItem(int index) {
    final removedItem = products[index];
    products.removeAt(index);
    key.currentState!.removeItem(
        index,
        (context, animation) => listItemWidget(
            item: removedItem, animation: animation, onClicked: () {}),
        duration: Duration(milliseconds: 400));
    if (products.length == 0) {
      setState(() {
        view = Center(
            child: Text('상품을 등록해주세요!',
                style: TextStyle(color: Colors.grey, fontSize: 20)));
      });
      tf = true;
    }
  }

  //리스트에 아이템 추가
  insertItem(String text) {
    final newIndex = 0;
    final newItem = ListItem(date: today, name: text);

    products.insert(newIndex, newItem);
    key.currentState!
        .insertItem(newIndex, duration: Duration(milliseconds: 400));
  }

  selectDate(){

  }

  //아이템 추가 다이얼로그 창
  void makeTile() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ListDialog(button: insertButton(), controller: textController);
        });
  }

  insertButton(){
    return ElevatedButton(onPressed: (){
      insertItem(textController.text);
      Navigator.pop(context);
      textController.clear();
    }, child: Text('추가'));
  }
}
