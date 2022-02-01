import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  // 필드명
  final String? uid;
  final String? comment;
  final String? name;
  final Timestamp? datetime;

  // 생성자
  CommentModel({
    this.uid,
    this.comment,
    this.name,
    this.datetime,
  });

  // firebase docs를 매개변수로 받아서 새로운 Model 객체를 반환하는 메서드
  factory CommentModel.fromDocumnet(DocumentSnapshot doc) {
    Map? getDocs = doc.data() as Map?;
    return CommentModel(
      uid: getDocs!["uid"],
      comment: getDocs["comment"],
      name: getDocs["name"],
      datetime: getDocs["datetime"],
    );
  }
}
