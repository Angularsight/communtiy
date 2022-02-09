import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/models/user_details/interests.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestList2 extends StatelessWidget {

  /// Guests and their interests who have entered the party
  final List<UserDetailsModel>? guests;
  final List<Interests>? interests;
  GuestList2({Key? key, this.guests, this.interests}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetX<FirebaseController>(
            builder: (controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Guests of this particular party fetched below"),
                  Text(guests![0].age.toString()),
                  Text(controller.parties[0].guests![1].toString()),
                  Flexible(
                    flex: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async{
                            openDialogBox(context, guests![0],interests!);
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
                                child: Text("Open dialog", style: TextStyle(color: Colors.black),
                                )),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      );
    }));
  }

  void openDialogBox(BuildContext context, UserDetailsModel guest,List<Interests> interests ) {
    var t =  const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold
    );
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 10,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: Get.width * 0.6,
                height: Get.height * 0.64,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: Get.width * 0.4,
                              height: Get.width * 0.7,
                              child: Image.network(
                                guest.userProfilePic.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20
                      ),
                       Text("Bio",style: t,),
                      Text("${interests[0].currentRelationshipStatus.toString()}${interests[1].currentRelationshipStatus.toString()}"),
                       Text("Favorite",style: t,),
                      Text(interests[1].anime![0].toString()),
                       Text("Hobbies and Likes",style: t,),
                      Text(interests[1].sport![0].toString()),
                       Text("INTERESTS",style: t,),
                      Text(interests[1].drama![0].toString())
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
