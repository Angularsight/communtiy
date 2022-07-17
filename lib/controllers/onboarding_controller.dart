

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/models/coupons/coupon_images.dart';
import 'package:communtiy/models/coupons/discountAndImage.dart';
import 'package:communtiy/models/user_details/interests.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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


  /// For checkout Page
  var appliedCoupon = ''.obs;
  var couponStreakNo = 0.obs; /// No coupon has streak=0, hence it can set as default value
  var couponIndex = -1.obs;
  var discountPartyFee = 0.obs;
  var discountPercent = 0.obs;


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

  Future<File> pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(selectedImage!.path);

    ///Image compression part
    var compressedFileUintList = await FlutterImageCompress.compressWithFile(
        pickedImageFile.absolute.path,
        quality: 25
    );
    final tempDirectory = await getTemporaryDirectory();
    final compressedFile = await File('${tempDirectory.path}/image.jpg').create();
    compressedFile.writeAsBytesSync(compressedFileUintList!);


    print("File length before compression:${pickedImageFile.lengthSync()}");
    print("File length after compression:${compressedFile.lengthSync()}");
    return compressedFile;
  }

  Future<String> uploadToStorage(String username,int i,File replacementImage)async{
    String url ='';
    final ref = FirebaseStorage.instance
        .ref()
        .child("users")
        .child(username)
        .child(username + i.toString() + '.jpg');
    await ref.putFile(replacementImage).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        url = value;
      });
    });
    return url;
  }

  Future<void> updateDataToFirebase(String userName,List newImages)async{
    var doc = await FirebaseFirestore.instance.collection("UserDetails").where('userName',isEqualTo: userName).get();
    String docId = doc.docs[0].id;

    FirebaseFirestore.instance.collection("UserDetails").doc(docId).update({
      'images':newImages
    });
  }

  Future<int> checkIfIdIsValid(List<String> ids)async{
    final res = await FirebaseFirestore.instance
        .collection("UserDetails")
        .where("userId",whereIn: ids)
        .get()
        .then((query) {
      var users = query.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
      return users;
    });
    print("result of checkUserExistence2:${res.length}");
    return res.length;
  }


  Future<void> updateStreaksOfFriends(String userId)async{
    ///Fetching user docId
    var userDoc = await FirebaseFirestore.instance.collection("UserDetails").where('userId',isEqualTo: userId).get();
    var docId = userDoc.docs[0].id;
    var userDetails = userDoc.docs.map((e) => UserDetailsModel.fromDocument(e)).toList()[0];

    FirebaseFirestore.instance.collection("UserDetails").doc(docId).update({
      'streaks':userDetails.streaks! + 1
    });

  }


}