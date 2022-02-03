import 'package:geolocator/geolocator.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LocationRepository {

  // 위치 권한
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
     
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    return await Geolocator.getCurrentPosition();
  }

  Future getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print(position.latitude);
    print(position.longitude);
    return await getCurrentAddr(position.latitude, position.longitude);
  }

  var gpsApiKey = "AIzaSyCWRscqA3Bp4U1DzY5xWhJh7751ILDaYOE";

  Future getCurrentAddr(x, y) async {
    // 현재 좌표로 주소 구하기
    String gpsUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${x},${y}&key=$gpsApiKey&language=ko';

    // 위치 조작
    // String gpsUrl =
    //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=37.47,126.66&key=$gpsApiKey&language=ko';



    final responseGps = await http.get(Uri.parse(gpsUrl));

    print(convert.jsonDecode(responseGps.body)['results']);

    // 대한민국 ##(도/시) ###(이부분을 가져옴)
    String addr = convert.jsonDecode(responseGps.body)['results'][0]
        ["address_components"][2]["long_name"];

    return addr;
  }
}
