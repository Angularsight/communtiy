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
  int? amountPaid;
  int? noOfTicketsBought;

  History(
      {this.partyDate,
      this.partyHost,
      this.partyId,
      this.partyImage,
      this.partyName,
      this.partyTime,
      this.partyVenue,
      this.qrDetail,
      this.amountPaid,
      this.noOfTicketsBought});

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
      qrDetail: d['qrDetail'],
      amountPaid: d['amountPaid'],
      noOfTicketsBought: d['noOfTicketsBought']
    );
  }


}
