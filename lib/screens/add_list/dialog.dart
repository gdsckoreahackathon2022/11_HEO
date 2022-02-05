import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study/controller/bottom_navigation_page_controller.dart';

class ListDialog extends StatefulWidget {
  Widget button;
  TextEditingController controller = new TextEditingController();

  ListDialog({required this.button, required this.controller, Key? key})
      : super(key: key);

  @override
  State<ListDialog> createState() => _ListDialogState();
}

class _ListDialogState extends State<ListDialog> {
  BottomNavigationPageController _bottomNavigationPageController =
      Get.put(BottomNavigationPageController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        content: Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 18.0,
                ),
                margin: EdgeInsets.only(top: 13.0, right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 180,
                        child: TextField(
                          controller: widget.controller,
                          decoration: InputDecoration(
                              hintText: '상품명을 입력해주세요',
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Colors.grey[400])),
                        ),
                      ),
                    ) //
                        ),
                    SizedBox(height: 10.0),
                    Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: widget.button),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 12.0,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.close, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
