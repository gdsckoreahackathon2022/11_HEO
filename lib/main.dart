import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study/screens/bottom_tapbar.dart';

import 'package:study/screens/home/home_screen.dart';
import 'package:study/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:study/screens/post/edit_screen.dart';
import 'package:study/screens/post/post_screen.dart';
import 'package:study/screens/post/post_detail_screen.dart';

import 'controller/crud_controller.dart';
import 'controller/image_crop_controller.dart';

Future<void> main() async {
  //Flutter Engine과의 상호작용을 위해 사용됨 (플랫폼 채널의 위젯 바인딩을 보장해야함.)
  WidgetsFlutterBinding.ensureInitialized(); //Firebase를 쓰기 전에 꼭 작성해줘야함.
  await Firebase.initializeApp(); //Firebase를 초기화 하기 위해서 네이티브 코드를 호출해야함.
  //firestore을 가져와서 사용하기 위해 FirebaseFirestore.instace; 코드 이전에 실행해줘야함.(registration_screen.dart의 signup 함수에서 사용)
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Color _primaryColor = Colors.green.shade300;
  Color _accentColor = Colors.amber.shade200;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Email and PW Login',
      theme: ThemeData(primaryColor: _primaryColor, accentColor: _accentColor),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      getPages: [
        GetPage(
            name: '/tap',
            page: () => tap(),
            ),
        
        GetPage(
            name: '/post',
            page: () => PostScreen(),
            binding: BindingsBuilder(() {
              Get.lazyPut<CRUDController>(() => CRUDController());
            })),
        GetPage(
            name: '/edit',
            page: () => EditScreen(),
            binding: BindingsBuilder(() {
              Get.lazyPut<ImageCropController>(() => ImageCropController());
              Get.lazyPut<CRUDController>(() => CRUDController());
            })),
        GetPage(
            name: '/postDetailScreen',
            page: () => PostDetailScreen(),
            binding: BindingsBuilder(() {
              Get.lazyPut<CRUDController>(() => CRUDController());
            })),
      ],
    );
  }
}
