

import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountAndImage{

  int? discount;
  String? image;
  String? name;
  String? code;
  List? couponUsedBy;

  DiscountAndImage({this.discount,this.image,this.name,this.code,this.couponUsedBy});

  factory DiscountAndImage.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    var d = snapshot.data();
    return DiscountAndImage(
      discount: d!['discount'],
      image: d['image'],
      name: d['name'],
      code: d['code'],
      couponUsedBy: d['couponUsedBy']
    );
  }

}