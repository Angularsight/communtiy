

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

  UserDetailsModel({ this.userId,
    this.userName,
    this.password,
    this.userProfilePic,
    this.phoneNumber,
    this.location,
    this.age,
    this.xp});


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
      phoneNumber: d['phoneNumber']
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