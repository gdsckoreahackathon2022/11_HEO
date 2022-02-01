import 'package:flutter/material.dart';
import 'package:study/model/list_item.dart';
import 'dialog.dart';


class listItemWidget extends StatefulWidget {
  ListItem item;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  listItemWidget(
      {required this.item,
      required this.animation,
      required this.onClicked,
      Key? key})
      : super(key: key);

  @override
  State<listItemWidget> createState() => _listItemWidgetState();
}

class _listItemWidgetState extends State<listItemWidget> {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) =>
      SizeTransition(sizeFactor: widget.animation, child: buildItem(context));

  Widget buildItem(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
      padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 150,
              child: TextButton(
                onPressed: (){
                  controller.text = widget.item.name;
                  Future.delayed(Duration.zero, ()=> modifyDialog(context));
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.item.name}',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                style: TextButton.styleFrom(primary: Colors.black),
              )),
          SizedBox(width: 10),
          Container(
              width: 100,
              child: TextButton(
                onPressed: () {
                  dateDialog();
                },
                child: Text(
                  '${widget.item.date}',
                  style: TextStyle(fontSize: 15),
                ),
                style: TextButton.styleFrom(primary: Colors.black),
              )),
          Align(
              alignment: Alignment.topRight,
              child: IconButton(onPressed: widget.onClicked, icon: Icon(Icons.close)))
        ],
      ),
    );
  }

  //수정 다이얼로그에 넣어지는 버튼
  modifyButton() {
    return ElevatedButton(onPressed: () {
      setState(() {
        widget.item.name = controller.text;
      controller.clear();
      });
      Navigator.pop(context);
    }, child: Text('수정'));
  }

  //텍스트를 선택했을 때 나타나는 수정 다이얼로그
  void modifyDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ListDialog(button: modifyButton(), controller: controller);
        });
  }

  //날짜 수정 다이얼로그
  dateDialog() async{
    final year = DateTime.now().year;

    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(year),
      lastDate: DateTime(year+3));

    setState(() {
          widget.item.date = dateTime.toString().split(' ')[0];

    });
  }
}
