

import 'package:cloud_firestore/cloud_firestore.dart';

class CouponImages{
  List? images;
  CouponImages({this.images});

  factory CouponImages.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    var d = snapshot.data();
    return CouponImages(
      images: d!['images']
    );
  }

}