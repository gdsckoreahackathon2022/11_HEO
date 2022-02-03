import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CRUDController extends GetxController {
  static CRUDController get to => Get.find();

  // 컬렉션명
  final String colName = "posts";

  // 필드명
  final String fnTitle = "title";
  final String fnDescription = "description";
  final String fnDatetime = "datetime";
  final String fnGps = "gps";
  final String fnImage = "imageUrl";
  final String fnPrice = "price";
  final String fnUid = "uid";
  final String fnPosition = "position";
  final String fnName = "name";
  final String fnComment = "comment";

  FirebaseAuth auth = FirebaseAuth.instance;

  // 유저 정보 가져오기
  String authUid() {
    return auth.currentUser!.uid;
  }

  // 유저 이메일 가져오기
  String authEmail() {
    return auth.currentUser!.email.toString();
  }

  /// Firestore CRUD Logic

  // 문서 생성 (Create)
  void createDoc(
      String title, String description, List image, String price, String uid, String currentPosition) {
    FirebaseFirestore.instance.collection(colName).doc(currentPosition).collection("post").add({
      fnTitle: title,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      fnImage: image,
      fnPrice: price,
      fnUid: uid,
      fnPosition: currentPosition
      
    });
  }

  // 문서 갱신 (Update)
  void updateDoc(
      String docID, String title, String description, List image, String price, String currentPosition) {
    FirebaseFirestore.instance.collection(colName).doc(currentPosition).collection("post").doc(docID).update({
      fnTitle: title,
      fnDescription: description,
      fnImage: image,
      fnPrice: price,
    });
  }

  // 문서 삭제 (Delete)
  void deleteDoc(String docID, String currentPosition) {
    FirebaseFirestore.instance.collection(colName).doc(currentPosition).collection("post").doc(docID).delete();
  }


  /// ************************************** commentScreen *********************************************************/
  
  // 문서 생성
  void createComment(
      String comment, String uid, String name, String postId) {
    FirebaseFirestore.instance.collection("comments").doc(postId).collection("comment").add({
      "comment": comment,
      fnDatetime: Timestamp.now(),
      fnUid: uid,
      fnName: name
    });
  }

  // 문서 삭제
  void deleteComment(String postId, String docID) {
    FirebaseFirestore.instance.collection("comments").doc(postId).collection("comment").doc(docID).delete();
  }
}
