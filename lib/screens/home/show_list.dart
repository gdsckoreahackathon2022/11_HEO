import 'package:flutter/material.dart';
import 'package:study/model/list_ingredient.dart';
import 'package:study/model/list_item.dart';

class ShowList extends StatefulWidget {
  ListIngredient ingredient;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  ShowList(
      {required this.ingredient,
      required this.animation,
      required this.onClicked,
      Key? key})
      : super(key: key);

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) =>
      SizeTransition(sizeFactor: widget.animation, child: buildItem(context));

  Widget buildItem(BuildContext context) {
    return Container(
      height: 75,
      margin: EdgeInsets.fromLTRB(25, 3, 25, 10),
      padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.lightGreen.shade100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(widget.ingredient.name,
                  style: TextStyle(
                    color: Colors.blueGrey.shade800,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 5,
              ),
              Text(widget.ingredient.expire,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  )),
            ],
          ),
          difdate(widget.ingredient.dday),
          IconButton(onPressed: widget.onClicked, icon: Icon(Icons.clear))
        ],
      ),
    );
  }

  Widget difdate(int expire) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 1, 30, 1),
        child: expire == 0
            ? Text('D-Day',
                style: TextStyle(
                    color: expire != 0 ? Colors.black : Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
            : expire > 0
                ? Text('D-$expire',
                    style: TextStyle(
                        color: expire != 0 ? Colors.black : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
                : Text('D+${expire * -1}',
                    style: TextStyle(
                        color: expire != 0 ? Colors.blue : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)));
  }
}
