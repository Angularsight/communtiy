import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:flutter/cupertino.dart';

class FirebaseProvider extends ChangeNotifier {
  var userDetailsList = [];
  var guestList = [];

  Stream<List<UserDetailsModel>> fetchUserDetails() {
    final result = FirebaseFirestore.instance
        .collection('UserDetails')
        .snapshots()
        .map((doc) {
      return doc.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
    });
    return result;
  }

  fetchUserDetails2() {
    final result = FirebaseFirestore.instance
        .collection('UserDetails')
        .snapshots()
        .map((doc) {
      return doc.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
    });
    userDetailsList.add(result);
    notifyListeners();
  }

  Stream<List<PartyDetails>> fetchPartyDetails() {
    final result = FirebaseFirestore.instance
        .collection('PartyDetails')
        .snapshots()
        .map((doc) {
          return doc.docs.map((e) => PartyDetails.fromDocument(e)).toList();
        });
    return result;
  }

  Stream<QuerySnapshot<Map<String,dynamic>>> fetchGuestList(){
    final result = FirebaseFirestore.instance.collection('PartyDetails').doc('SWVe8XKSDDTB4bprHJyi').collection('GuestList').snapshots();

    return result;
  }


  Stream<QuerySnapshot<Map<String,dynamic>>> fetchGuestListFromUserDetails2(List<String> guests){
    final result = FirebaseFirestore.instance.collection('UserDetails').where('userId',whereIn: guests).snapshots();
    return result;
  }

}
