

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel {
  String? userId;
  String? userName;
  String? password;
  String? userProfilePic;
  int? phoneNumber;
  String? location;
  int? age;
  int? xp;
  List? images;
  int? streaks;

  UserDetailsModel({ this.userId,
    this.userName,
    this.password,
    this.userProfilePic,
    this.phoneNumber,
    this.location,
    this.age,
    this.xp,
    this.images,
    this.streaks
  });


  factory UserDetailsModel.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    final d = snapshot.data();
    return UserDetailsModel(
        userId: d!['userId'],
        userName: d['userName'],
        userProfilePic: d['userProfilePic'],
        password: d['password'],
        location: d['location'],
        age: d['age'],
        xp: d['xp'],
        phoneNumber: d['phoneNumber'],
        images: d['images'],
        streaks: d['streaks']
    );
  }

  UserDetailsModel.fromJson(Map<String,dynamic> snapshot){
    userId = snapshot['userId'] ?? "";
    userName = snapshot['userName'] ?? '';
    password = snapshot['password'] ?? '' ;
    userProfilePic = snapshot['userProfilePic']?? '' ;
    phoneNumber = snapshot['phoneNumber']?? '' ;
    location = snapshot['Geolocation']?? '';
    age = snapshot['age']?? '';
    xp = snapshot['xp']?? '';
  }

}