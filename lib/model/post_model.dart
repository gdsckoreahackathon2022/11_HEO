import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  // 필드명
  final String? uid;
  final String? title;
  final String? description;
  final Timestamp? datetime;
  final String? gps;
  final List? imageUrl;
  final String? price;
  final String? position;

  // 생성자
  PostModel(
      {this.uid,
      this.title,
      this.description,
      this.datetime,
      this.gps,
      this.imageUrl,
      this.price,
      this.position});

  // firebase docs를 매개변수로 받아서 새로운 Model 객체를 반환하는 메서드
  factory PostModel.fromDocumnet(DocumentSnapshot doc) {
    Map? getDocs = doc.data() as Map?;
    return PostModel(
      uid: getDocs!["uid"],
      title: getDocs["title"],
      description: getDocs["description"],
      datetime: getDocs["datetime"],
      gps: getDocs["gps"],
      imageUrl: getDocs["imageUrl"],
      price: getDocs['price'],
      position:getDocs["position"]
    );
  }
}
