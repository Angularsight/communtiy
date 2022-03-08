

class Interests{

  final List<String> anime;
  final List<String> drama;
  final List<String> movies;
  final List<String> series;
  final List<String> sport;
  final String currentRelationshipStatus;
  final String height;
  final String pet;

  Interests(this.anime, this.drama, this.movies, this.series, this.sport, this.currentRelationshipStatus, this.height, this.pet);


  factory Interests.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
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
        date: d['date']
    );

  }

}
