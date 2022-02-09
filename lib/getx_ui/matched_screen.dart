


import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchedScreen extends StatelessWidget {
  MatchedScreen({Key? key}) : super(key: key);

  final FirebaseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<FirebaseController>(
          // init: Get.put(FirebaseController()),
          builder: (controller){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Party Details Imported"),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(controller.parties[0].images![0].toString(),fit: BoxFit.cover,),
                ),
                const SizedBox(height: 40,),
                const Text("List of all parties and their first image",),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        return SizedBox(
                          width: Get.width * 0.3,
                          height: 190,
                          child: Image.network(controller.parties[index].images![0].toString(),fit: BoxFit.cover,),
                        );
                        }, separatorBuilder: (context,index)=>const SizedBox(width: 10,), itemCount: controller.parties.length),
                ),
                const SizedBox(height: 100,),

                TextButton(
                  onPressed: () {
                    Get.to(() =>  PartyDetails2());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                            colors: [Colors.red, Colors.yellow],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: const Center(
                        child: Text(
                          "Party Details",
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
