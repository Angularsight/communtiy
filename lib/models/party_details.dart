

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PartyDetails with ChangeNotifier{

  final String? partyName;
  final String? partyId;
  final String? partyHostId;
  final String? hostId;
  final int? entryFee;
  final String? description;
  final String? location;
  final String? time;

  PartyDetails(
      {this.partyName, this.partyId, this.partyHostId, this.hostId, this.entryFee, this.description, this.location, this.time});

  factory PartyDetails.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    final d = snapshot.data();
    return PartyDetails(
      partyName: d!['partyName'],
      partyId: d['partyId'],
      partyHostId: d['partyHostId'],
      hostId: d['hostId'],
      entryFee: d['entryFee'],
      description: d['description'],
      location: d['location'],
      time: d['time']
    );

  }


}