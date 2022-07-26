import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/models/host/host.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/models/user_details/interests.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_details/history.dart';

class FirebaseController extends GetxController {

  ///Getting instance of OnboardingController
  // final OnBoardingController onBoardingController = Get.put(OnBoardingController());

  final _parties = [PartyDetails()].obs;
  List<PartyDetails> get parties => _parties.value;

  final _userDetail = [UserDetailsModel()].obs;
  List<UserDetailsModel> get userDetails => _userDetail.value;


  // final _userProfile = UserDetailsModel().obs;
  // UserDetailsModel get userProfile => _userProfile.value;

  final _hostDetails = [HostModel()].obs;
  List<HostModel> get hostDetails => _hostDetails.value;

  final _guests = [UserDetailsModel()].obs;
  List<UserDetailsModel> get guests => _guests.value;


  var queryComplete = false.obs;
  var userQueryImages = <UserDetailsModel>[].obs;
  var partyQueryImages = <PartyDetails>[].obs;

  RxInt pageIndicatorIndex = 0.obs;
  RxInt partyIndexForMatchedPage = 0.obs;




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _parties.bindStream(fetchPartyFromFirebase());

  }

  /// Fetches all parties
  Stream<List<PartyDetails>> fetchPartyFromFirebase() {
    return FirebaseFirestore.instance
        .collection('PartyDetails')
        .where('isValid',isEqualTo: true)
        .snapshots()
        .map((query) {
      return query.docs.map((e) => PartyDetails.fromDocument(e)).toList();
    });
  }


  Future<List<HostModel>> fetchHostDetailsFuture(String hostId) async{
    return FirebaseFirestore.instance.collection('Host').where('hostId',isEqualTo: hostId).get().then((query) {
      _hostDetails.value = query.docs.map((e) => HostModel.fromDocument(e)).toList();
      return _hostDetails.value;
    });
  }



  /// Fetching interests whenever an element in the guestList is tapped
  Future<List<Interests>> fetchGuestsInterests(List guestsId)async{
    for (var element in guestsId) {
      element.toString();
    }
    return FirebaseFirestore.instance.collection('Interests').where('userId',whereIn: guestsId).get().then((query) {
      var v = query.docs.map((e) => Interests.fromDocument(e)).toList();
      return v;
    });
  }


  /// Fetches all guests invited to a party
  Future<List<UserDetailsModel>> fetchGuests(List query)async{
    for (var element in query) {
      element.toString();
    }
    return FirebaseFirestore.instance.collection('UserDetails').where('userId',whereIn: query).get().then((querySnap) {
      _guests.value = querySnap.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
      return _guests.value;
    });
  }

  /// Search Bar Query For Parties
  Future<List<PartyDetails>> searchQueryParty(String query)async{
    return FirebaseFirestore.instance.collection('PartyDetails').where('partyName',isEqualTo: query).get().then((querySnap) {
      return querySnap.docs.map((e) => PartyDetails.fromDocument(e)).toList();
    });
  }

  /// Search Bar Query For Users or People
  Future<List<UserDetailsModel>> searchQueryUser(String query)async{
    return FirebaseFirestore.instance.collection('UserDetails').where('userName',isEqualTo: query).get().then((querySnap) {
      var v = querySnap.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
      return v;
    });
  }



  /// Suggestions loader in TypeAhead text field
  Future<List<PartyDetails>> partyQuerySuggestions(String query)async{
    var v = await FirebaseFirestore.instance.collection('PartyDetails').get();
    return v.docs.map((doc) => PartyDetails.fromDocument(doc)).where((party) {
      final partyName = party.partyName!.toLowerCase();
      final inputQuery = query.toLowerCase();
      return partyName.contains(inputQuery);
    }).toList();
  }


  Future<List<History>> fetchPartiesHistory(String userId) async{
    return FirebaseFirestore.instance.collection('UserDetails').doc(userId).collection("History").get().then((querySnap) {
      var v = querySnap.docs.map((e) => History.fromDocument(e)).toList();
      return v;
    });
  }



}