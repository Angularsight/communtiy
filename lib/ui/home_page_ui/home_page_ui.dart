import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/providers/firebase_provider.dart';
import 'package:communtiy/ui/home_page_ui/party_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageUi extends StatelessWidget {
  final AsyncSnapshot<List<PartyDetails>> snapshot;
  const HomePageUi({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("${snapshot.data![0].partyName}"),
          ),
          const SizedBox(
            height: 100,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PartyDetailsPage(partySnapshot: snapshot,)));
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
                child: const Center(child:Text("Party Details",style: TextStyle(
                  color: Colors.black
                ),)),
              ),

          )
        ],
      ),
    );
  }
}
