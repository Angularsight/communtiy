

import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountAndImage{

  int? discount;
  String? image;
  String? name;

  DiscountAndImage({this.discount,this.image,this.name});

  factory DiscountAndImage.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    var d = snapshot.data();
    return DiscountAndImage(
      discount: d!['discount'],
      image: d['image'],
      name: d['name']
    );
  }

}