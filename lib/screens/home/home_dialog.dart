import 'package:flutter/material.dart';
import 'package:study/model/list_ingredient.dart';

class HomeDialog extends StatefulWidget {
  ListIngredient ingredient;
  HomeDialog({required this.ingredient, Key? key}):super(key: key);
  @override
  State<HomeDialog> createState() => _HomeDialogState();
}

class _HomeDialogState extends State<HomeDialog> {
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
                    //식재료 이름
                    Text(widget.ingredient.name),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 180,
                        //판매 버튼
                        child: MaterialButton(
                          color: Colors.green.shade300,
                          onPressed: () {
                            //글쓰기 페이지에 객체 넘겨주기
                          },
                          child: Text('Sell'),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                        ),
                      ),
                    )),
                    //레시피 추천 버튼
                    MaterialButton(
                      color: Colors.green.shade300,
                      onPressed: () {},
                      child: Text('Recipe recommendation'),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                    ),
                  ],
                ),
              ),
              //x버튼
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