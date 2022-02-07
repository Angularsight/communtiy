

import 'package:cloud_firestore/cloud_firestore.dart';

class HostModel{
  int? age;
  String? hostId;
  String? hostName;
  String? location;
  String? password;
  String? phoneNumber;
  String? profilePic;
  int? xp;

  HostModel({this.age,this.hostId,this.hostName,this.location,this.password,this.phoneNumber,this.profilePic,this.xp});

  factory HostModel.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    final d = snapshot.data();
    return HostModel(
        age: d!['age'],
        hostId: d['hostId'],
        hostName: d['hostName'],
        location: d['location'],
        password: d['password'],
        profilePic: d['profilePic'],
        xp: d['xp'],
    );
  }

}