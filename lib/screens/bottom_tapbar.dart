import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study/controller/bottom_navigation_page_controller.dart';
import 'package:study/repository/location_repository.dart';

class tap extends StatefulWidget {
  @override
  _tapState createState() => _tapState();
}

class _tapState extends State<tap> {
  LocationRepository _locationRepository = LocationRepository();
  BottomNavigationPageController _bottomNavigationPageController =
      Get.put(BottomNavigationPageController());
  late String currentPosition;

  @override
  void initState() {
    super.initState();
    _locationRepository.determinePosition();
    locationCheck().then((value) async => {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        body: _bottomNavigationPageController.currentPage,
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
              backgroundColor: Colors.green.shade300,
              selectedFontSize: 13.0,
              selectedItemColor: Colors.green.shade900,
              unselectedFontSize: 10.0,
              unselectedItemColor: Colors.grey.shade200,
              type: BottomNavigationBarType.fixed,
              elevation: 5.0,
              currentIndex: _bottomNavigationPageController.currentIndex.value,
              onTap: _bottomNavigationPageController.changePage,
              items: [
                new BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: ("Home"),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sell,
                    size: 30,
                  ),
                  label: ("Community"),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  label: ("my"),
                ),
              ]),
        )));
  }

  Future locationCheck() async {
    currentPosition = await _locationRepository.getCurrentLocation();
  }
}
