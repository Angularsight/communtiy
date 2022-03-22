import 'package:cloud_firestore/cloud_firestore.dart';

class Interests {
  String? userId;
  List? anime;
  List? drama;
  List? movies;
  List? series;
  List? sport;
  String? occupation;
  String? currentRelationshipStatus;
  String? height;
  String? pet;

  Interests(
      {this.userId,
        this.anime,
        this.drama,
        this.movies,
        this.series,
        this.sport,
        this.occupation,
        this.currentRelationshipStatus,
        this.height,
        this.pet});

  factory Interests.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final d = snapshot.data();
    return Interests(
        userId: d!['userId'],
        anime: d['anime'],
        drama: d['drama'],
        movies: d['movies'],
        series: d['series'],
        sport: d['sports'],
        occupation: d['occupation'],
        currentRelationshipStatus: d['currentRelationshipStatus'],
        height: d['height'],
        pet: d['pet']
    );
  }
}