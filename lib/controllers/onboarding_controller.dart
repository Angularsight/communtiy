

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController{
  var animeList = List<String>.empty(growable: true).obs;
  var dramaList = List<String>.empty(growable: true).obs;
  var movies = List<String>.empty(growable: true).obs;
  var series = List<String>.empty(growable: true).obs;
  var sports = List<String>.empty(growable: true).obs;

  var animeIsOpen = false.obs;
  var dramaIsOpen = false.obs;
  var moviesIsOpen = false.obs;
  var seriesIsOpen = false.obs;
  var sportsIsOpen = false.obs;

  var phoneNumber = 0.obs;
  var holdRerouteBool = true;

  final _userProfile = UserDetailsModel().obs;
  Rx<UserDetailsModel> get userProfile => _userProfile;
  final currentUser = FirebaseAuth.instance.currentUser!;

  Stream<UserDetailsModel> connectUserToApp(){

    if(currentUser.phoneNumber!.isNotEmpty){
      // print('OnBoarding Phone No:${currentUser.phoneNumber}');
      // String formattedPhoneNo = currentUser.phoneNumber!.substring(3);
      // print('Formatted Phone No:$formattedPhoneNo');
      // print("currentId:${currentUser.uid}");
      var res = FirebaseFirestore.instance.collection('UserDetails')
          .where('userId',isEqualTo: currentUser.uid)
          .snapshots()
          .map((query) {
        var user = query.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
        // print('connectUserToApp error :$user');
        return user[user.length-1];
      });
      return res;
    }else{
      // print('Formatted Phone No:$formattedPhoneNo');
      var res = FirebaseFirestore.instance.collection('UserDetails')
          .where('userId',isEqualTo: currentUser.uid)
          .snapshots()
          .map((query) {
        var user = query.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
        print('connectUserToApp error :$user');
        return user[0];
      });
      return res;
    }

  }


  /// Connecting the user to the account he has created
  // Stream<UserDetailsModel> connectUserToApp(int phoneNumber){
  //   var res = FirebaseFirestore.instance.collection('UserDetails')
  //       .where('phoneNumber',isEqualTo: phoneNumber)
  //       .snapshots()
  //       .map((query) {
  //     var user = query.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
  //     print('connectUserToApp error :$user');
  //     return user[0];
  //   });
  //   return res;
  // }



}