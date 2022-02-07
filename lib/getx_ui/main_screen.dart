import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final partyController = Get.put(FirebaseController());
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  bool queryComplete = false;
  List<UserDetailsModel> userQueryImages = [];
  List<PartyDetails> partyQueryImages = [];

  int imagesLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              flex: 8,
              child: GetX<FirebaseController>(builder: (controller) {
                /// Search Bar Queries
                /// For both users and parties
                return TextField(
                  focusNode: searchFocusNode,
                  controller: searchController,
                  autocorrect: true,
                  autofocus: false,
                  decoration: InputDecoration(
                    focusColor: Colors.transparent,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.none)),
                    filled: true,
                    hintText: controller.parties[0].partyName.toString(),
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5)
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  onEditingComplete: () async {
                    Future.wait([
                      controller.searchQueryUser(searchController.text).then((value) {
                        queryComplete = true;
                        searchFocusNode.unfocus();
                        userQueryImages = value;
                      }),
                      controller.searchQueryParty(searchController.text).then((value) {
                        queryComplete = true;
                        searchFocusNode.unfocus();
                        partyQueryImages = value;
                      })
                    ]);
                  },
                );
              })),
          Flexible(
            flex: 8,
            child: GetX<FirebaseController>(builder: (controller) {
              if (controller.parties == null && controller == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    /// Displaying image if search query request is successful
                    /// Else displaying an empty SizedBox() instead of its place
                    queryComplete ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                      if(userQueryImages.isEmpty){
                                        return Image.network(partyQueryImages[0].images![index], fit: BoxFit.cover,);
                                      }else{
                                        return Image.network(userQueryImages[0].images![index], fit: BoxFit.cover,);
                                      }
                                    },
                                  separatorBuilder: (context, index) => const SizedBox(width: 10,),
                                  itemCount: 2,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                          ) : const SizedBox(),
                    const SizedBox(
                      height: 30,
                    ),
                    Text("${controller.parties[0].time}"),
                  ],
                );
              }
            }),
          ),
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Get.to(() => const PartyDetails2());
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
            ),
          )
        ],
      ),
    );
  }
}
