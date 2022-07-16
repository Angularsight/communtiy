

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/models/coupons/coupon_images.dart';
import 'package:communtiy/models/coupons/discountAndImage.dart';
import 'package:communtiy/models/user_details/interests.dart';
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

  RxInt carouselIndicatorIndex = 0.obs;


  final _userProfile = UserDetailsModel().obs;
  Rx<UserDetailsModel> get userProfile => _userProfile;
  final currentUser = FirebaseAuth.instance.currentUser!;
  var userDocId = '';

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
            if(user.isNotEmpty){
              _userProfile.value = user[0];
            }
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


  Future<String> fetchUserDocId() async{
    var userDoc = await FirebaseFirestore.instance.collection("UserDetails").where('userId',isEqualTo: currentUser.uid).get();
    var userDocId = userDoc.docs[0].id;
    return userDocId;
  }

  Future<Interests> fetchUserInterests(String userId)async{
    var interests = await FirebaseFirestore.instance.collection('Interests').where('userId',isEqualTo: userId).get().then((querySnapshot) {
      var result = querySnapshot.docs.map((doc) => Interests.fromDocument(doc)).toList();
      return result[0];
    });
    return interests;
  }

  Future<CouponImages>fetchCouponImages()async{
    var v = await FirebaseFirestore.instance.collection('Coupons').doc('Images').get().then((query) {
      var result = CouponImages.fromDocument(query);
      return result;
    });
    return v;
  }

  Future<List<DiscountAndImage>>fetchDiscountAndImages()async{
    var v = await FirebaseFirestore.instance.collection('CouponCodes').orderBy('discount',descending: false).get().then((query) {
      var result = query.docs.map((e) => DiscountAndImage.fromDocument(e)).toList();
      return result;
    });
    return v;
  }


}