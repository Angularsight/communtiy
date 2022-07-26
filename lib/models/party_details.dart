

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
  final String? date;
  final List? guests;
  final List? images;
  final bool? isValid;

  final bool? specialAppearance;
  final String? djName;
  final List? playing;
  final String? djPhoto;
  final List? activities;

  PartyDetails(
      {this.partyName, this.partyId, this.partyHostId, this.hostId, this.entryFee, this.description, this.location, this.time,this.date,this.guests,this.images,this.isValid,this.specialAppearance, this.djName, this.playing, this.djPhoto, this.activities, });

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
        time: d['time'],
        guests:d['guests'],
        images:d['images'],
        date: d['date'],
      specialAppearance: d['specialAppearance'],
      djName: d['djName'],
      playing: d['playing'],
      djPhoto: d['djPhoto'],
      activities: d['activities'],
      isValid: d['isValid']
    );

  }


}