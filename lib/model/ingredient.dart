import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  // 필드
  String user;
  String name;
  String date;

  // 생성자
  Ingredient({
    required this.user,
    required this.name,
    required this.date,
  });

  // firebase docs를 매개변수로 받아서 새로운 Ingredient 객체를 반환하는 메서드
  factory Ingredient.fromDocumnet(DocumentSnapshot doc) {
    Map? getDocs = doc.data() as Map?;
    return Ingredient(
      user: getDocs!['user'],
      name: getDocs['name'],
      date: getDocs['date']
    );
  }
}