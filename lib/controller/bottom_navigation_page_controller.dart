import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study/screens/add_list/add_list_screen.dart';
import 'package:study/screens/home/home_screen.dart';
import 'package:study/screens/post/post_screen.dart';
import 'package:study/screens/mypage/info.dart';

class BottomNavigationPageController extends GetxController {
  final currentIndex = 0.obs;

  List<dynamic> _screen = [HomeScreen(), PostScreen(), info()];
  
  Widget get currentPage => _screen[currentIndex.value]; // currentIndex.value에 따라서 page 전환
  
  // 상태 관리
  void changePage(int _index) {
    currentIndex.value = _index;
  }
}
