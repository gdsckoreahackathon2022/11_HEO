import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CRUDController extends GetxController {
  static CRUDController get to => Get.find();

  // 컬렉션명
  final String colName = "post";

  // 필드명
  final String fnName = "name";
  final String fnDescription = "description";
  final String fnDatetime = "datetime";
  final String fnGps = "gps";
  final String fnImage = "imageUrl";
  final String fnPrice = "price";
  final String fnUid = "uid";

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
      String name, String description, List image, String price, String uid) {
    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      fnImage: image,
      fnPrice: price,
      fnUid: uid
    });
  }

  // 문서 갱신 (Update)
  void updateDoc(
      String docID, String name, String description, List image, String price) {
    FirebaseFirestore.instance.collection(colName).doc(docID).update({
      fnName: name,
      fnDescription: description,
      fnImage: image,
      fnPrice: price,
    });
  }

  // 문서 삭제 (Delete)
  void deleteDoc(String docID) {
    FirebaseFirestore.instance.collection(colName).doc(docID).delete();
  }




  /// ************************************** commentScreen *********************************************************/
 
  void createComment(
      String comment, String uid, String name, String postId) {
    FirebaseFirestore.instance.collection("comments").doc(postId).collection("comment").add({
      "comment": comment,
      fnDatetime: Timestamp.now(),
      fnUid: uid,
      fnName: name
    });
  }

  void deleteComment(String postId, String docID) {
    FirebaseFirestore.instance.collection("comments").doc(postId).collection("comment").doc(docID).delete();
  }
}
