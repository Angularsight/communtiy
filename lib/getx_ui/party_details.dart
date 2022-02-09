import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/guest_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PartyDetails2 extends StatelessWidget {
   PartyDetails2({Key? key}) : super(key: key);

  final FirebaseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetX<FirebaseController>(
            // init: Get.put(FirebaseController()),
              builder: (controller) {
            if (controller.parties == null && controller == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Party Details imported as shown below"),
                  Container(
                    width: Get.width * 0.5,
                    height: Get.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          var image = Image.network(controller.parties[0].images![index], fit: BoxFit.cover,);
                          if(image==null){
                            return const Center(child:CircularProgressIndicator());
                          }else{
                            return image;
                          }
                        },
                        separatorBuilder: (context, index) => const SizedBox(width: 10,),
                        itemCount: controller.parties[0].images!.length,scrollDirection: Axis.horizontal,),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("User details imported as shown below"),
                  Container(
                      width:MediaQuery.of(context).size.height * 0.2,
                    height:MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(controller.userDetails[0].userProfilePic.toString()),fit: BoxFit.cover)
            ),
                      // child: Image.network(controller.userDetails[0].userProfilePic.toString(),fit: BoxFit.cover,)
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Host details imported as shown below"),
                  SizedBox(
                      width:MediaQuery.of(context).size.height * 0.2,
                      height:MediaQuery.of(context).size.height * 0.2,
                      child: Image.network(controller.hostDetails[0].profilePic.toString(),fit: BoxFit.cover,) ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async{

                          /// Fetching Guests and their interests of that particular party
                          var v = await controller.fetchGuestsInterests(controller.parties[0].guests!);
                          await controller.fetchGuests(controller.parties[0].guests!).then((guests) {
                            return Get.to(() =>  GuestList2(guests: guests,interests: v,));
                          });

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
                                "Guest List Page",
                                style: TextStyle(color: Colors.black),
                              )),
                        ),
                      ),
                    ],
                  ),

                ],
              );
            }
          }),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     TextButton(
          //       onPressed: () {
          //         Get.to(() =>  GuestList2());
          //       },
          //       child: Container(
          //         width: MediaQuery.of(context).size.width * 0.3,
          //         height: 40,
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(20),
          //             gradient: const LinearGradient(
          //                 colors: [Colors.red, Colors.yellow],
          //                 begin: Alignment.topLeft,
          //                 end: Alignment.bottomRight)),
          //         child: const Center(
          //             child: Text(
          //           "Guest List Page",
          //           style: TextStyle(color: Colors.black),
          //         )),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
