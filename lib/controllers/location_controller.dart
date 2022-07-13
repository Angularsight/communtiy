

import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController{

  var latitude = ''.obs;
  var longitude = ''.obs;
  var address = ''.obs;
  Position? currentPosition;
  late StreamSubscription locationSubscription;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLocation();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    locationSubscription.cancel();
  }

  void getLocation()async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(serviceEnabled==false){
      await Geolocator.openLocationSettings();
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error("Location permissions are required");
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error("Location Permissions are permanently denied, we cannot request permission");
    }

    currentPosition = await Geolocator.getCurrentPosition();
    getAddressFromLatLng(currentPosition);
    // locationSubscription = Geolocator.getPositionStream().listen((Position p) {
    //   latitude.value = p.latitude.toString();
    //   longitude.value = p.longitude.toString();
    //   getAddressFromLatLng(p);
    // });


  }

  Future<void> getAddressFromLatLng(Position? currentPosition)async{
    List<Placemark> placeMarks = await placemarkFromCoordinates(currentPosition!.latitude, currentPosition.longitude);
    address.value = "${placeMarks[0].subLocality},${placeMarks[0].locality}-${placeMarks[0].postalCode}";
    print("User address:${address.value}");
  }

}