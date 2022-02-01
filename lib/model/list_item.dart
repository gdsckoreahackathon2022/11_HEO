import 'package:cloud_firestore/cloud_firestore.dart';

class ListItem{
  String name;
  String date;

  ListItem({
    required this.name,
    required this.date
  });
}