import 'package:get/get.dart';

class UsersController extends GetxController {
  String nickName = "";
  String phonNumber = "";

  // 상태 관리
  // 주소를 받아 구독하고 있는 곳에 뿌려준다.
  setData( nick,  phon) {
    nickName = nick;
    phonNumber = phon;

    update();
  }
}
