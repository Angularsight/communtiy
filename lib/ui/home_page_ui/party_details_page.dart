import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:communtiy/providers/firebase_provider.dart';
import 'package:communtiy/utils/mutli_stream_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'guest_list_page.dart';

class PartyDetailsPage extends StatelessWidget {
  final AsyncSnapshot<List<PartyDetails>> partySnapshot;
  const PartyDetailsPage({Key? key,required this.partySnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var guestListQuery = Provider.of<FirebaseProvider>(context).fetchGuestList();

    return Scaffold(
        body: StreamBuilder(
            stream: guestListQuery,
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                var guests = snapshot.data!.docs[0].data();
                var streams = <String>[];

                //Fetching all the userIds of guests and storing it in streams
                guests.forEach((key, value) {
                  streams.add(value.toString());
                });
                var guestList = FirebaseProvider().fetchGuestListFromUserDetails2(streams);
                return StreamBuilder(
                    stream: guestList,
                    builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                      if(snapshot.hasData){
                        var guests = snapshot.data!.docs.map((doc) => UserDetailsModel.fromDocument(doc)).toList();
                        var party = partySnapshot.data![0];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text("${guests[0].userProfilePic},\n${party.partyName}")),

                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> GuestListPage(guests:guests)));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 40,
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                        colors: [Colors.red, Colors.yellow],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)),
                                child: const Center(child:Text("GuestPage",style: TextStyle(
                                    color: Colors.black
                                ),)),
                              ),

                            )
                          ],
                        );
                      }
                      print('Error Inside : ${snapshot.error}');
                      return const CircularProgressIndicator();

                    });


                  // return StreamBuilder(
                  //     stream: FirebaseProvider().fetchGuestListFromUserDetails(guests['guest1']),
                  //     builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                  //       if(snapshot.hasData){
                  //         return Center(child: Text("${snapshot.data!.docs[0].data()}"));
                  //       }
                  //       print('Error Inside : ${snapshot.error}');
                  //       return const CircularProgressIndicator();
                  //
                  //     });


              }
              print('Error : ${snapshot.error}');
              return const CircularProgressIndicator();
            }));
  }
}
