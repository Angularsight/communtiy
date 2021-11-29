
import 'dart:html';

class PartyDetails{

  final String partyName;
  final String partyId;
  final String partyHostId;
  final String hostId;
  final int entryFee;
  final String description;
  final Geolocation location;
  final DateTime time;

  PartyDetails(this.partyName, this.partyId, this.partyHostId, this.hostId, this.entryFee, this.description, this.location, this.time);


}