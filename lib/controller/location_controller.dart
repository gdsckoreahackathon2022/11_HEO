import 'package:get/get.dart';

class LocationController extends GetxController {

  String addr = "";

  // 상태 관리
  // 주소를 받아 구독하고 있는 곳에 뿌려준다.
  getPosition(position) {
    addr = position;
    update();
  }

}
