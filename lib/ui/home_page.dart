import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:communtiy/providers/firebase_provider.dart';
import 'package:communtiy/ui/home_page_ui/home_page_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<FirebaseProvider>(context).fetchPartyDetails();
    return  Scaffold(
      body: StreamBuilder(
          stream: userDetailsProvider,
          builder: (context,AsyncSnapshot<List<PartyDetails>> snapshot){
        if(snapshot.hasData){
          return HomePageUi(snapshot:snapshot);
        }
        print('Error--> ${snapshot.error}');
        return const Center(child:CircularProgressIndicator());
      })
    );
  }
}
