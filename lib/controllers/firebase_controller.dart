import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/models/host/host.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  final _parties = [PartyDetails()].obs;
  List<PartyDetails> get parties => _parties.value;

  final _userDetail = [UserDetailsModel()].obs;
  List<UserDetailsModel> get userDetails => _userDetail.value;


  final _hostDetails = [HostModel()].obs;
  List<HostModel> get hostDetails => _hostDetails.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _parties.bindStream(fetchPartyFromFirebase());
    Future.delayed(const Duration(seconds: 3), () {
      _userDetail.bindStream(fetchUserDetails(_parties[0].guests!));
    });
    Future.delayed(const Duration(seconds: 2), () {
      _hostDetails.bindStream(fetchHostDetails(_parties[0].hostId!));
    });

  }

  Stream<List<PartyDetails>> fetchPartyFromFirebase() {
    return FirebaseFirestore.instance
        .collection('PartyDetails')
        .snapshots()
        .map((query) {
      return query.docs.map((e) => PartyDetails.fromDocument(e)).toList();
    });
  }

  Stream<List<UserDetailsModel>> fetchUserDetails(List users) {
    for (var element in users) {
      element = element.toString();
    }
    var res = FirebaseFirestore.instance
        .collection('UserDetails')
        .where("userId", whereIn: users)
        .snapshots()
        .map((query) {
      var guests =
          query.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
      return guests;
    });
    print('Result : $res');
    return res;
  }

  Stream<List<HostModel>> fetchHostDetails(String hostId) {
    return FirebaseFirestore.instance.collection('Host').where('hostId',isEqualTo: hostId).snapshots().map((query) {
      return query.docs.map((e) => HostModel.fromDocument(e)).toList();
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

  Future<List<UserDetailsModel>> fetchGuests(String query)async{
    return FirebaseFirestore.instance.collection('UserDetails').where('userId',isEqualTo: query).get().then((querySnap) {
      var v = querySnap.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
      return v;
    });
  }
  
  
  
}
