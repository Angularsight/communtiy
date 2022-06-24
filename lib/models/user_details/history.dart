import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  String? partyDate;
  String? partyHost;
  String? partyId;
  String? partyImage;
  String? partyName;
  String? partyTime;
  String? partyVenue;
  String? qrDetail;

  History(
      {this.partyDate,
      this.partyHost,
      this.partyId,
      this.partyImage,
      this.partyName,
      this.partyTime,
      this.partyVenue,
      this.qrDetail});

  factory History.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    final d = snapshot.data();
    return History(
      partyDate: d!['partyDate'],
      partyHost: d['partyHost'],
      partyId: d['partyId'],
      partyImage: d['partyImage'],
      partyName: d['partyName'],
      partyTime: d['partyTime'],
      partyVenue: d['partyVenue'],
      qrDetail: d['qrDetail']
    );
  }


}
