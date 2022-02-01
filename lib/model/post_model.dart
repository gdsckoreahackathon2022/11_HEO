import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  // 필드명
  final String? uid;
  final String? name;
  final String? description;
  final Timestamp? datetime;
  final String? gps;
  final List? imageUrl;
  final String? price;

  // 생성자
  PostModel(
      {this.uid,
      this.name,
      this.description,
      this.datetime,
      this.gps,
      this.imageUrl,
      this.price});

  // firebase docs를 매개변수로 받아서 새로운 Model 객체를 반환하는 메서드
  factory PostModel.fromDocumnet(DocumentSnapshot doc) {
    Map? getDocs = doc.data() as Map?;
    return PostModel(
      uid: getDocs!["uid"],
      name: getDocs["name"],
      description: getDocs["description"],
      datetime: getDocs["datetime"],
      gps: getDocs["gps"],
      imageUrl: getDocs["imageUrl"],
      price: getDocs['price']
    );
  }
}
