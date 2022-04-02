


import 'package:accordion/accordion.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class InterestsUpload extends StatelessWidget {
  InterestsUpload({Key? key,}) : super(key: key);

  final OnBoardingController interestController = Get.find();

  final TextEditingController animeEditingController = TextEditingController();
  final TextEditingController seriesEditingController = TextEditingController();
  final TextEditingController movieEditingController = TextEditingController();
  final TextEditingController dramaEditingController = TextEditingController();
  final TextEditingController sportsEditingController = TextEditingController();

  final FocusNode animeNode = FocusNode();
  final FocusNode seriesNode = FocusNode();
  final FocusNode movieNode = FocusNode();
  final FocusNode dramaNode = FocusNode();
  final FocusNode sportsNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildCustomInterestTile(w, h, context,"Anime",animeNode, animeEditingController, interestController.animeList,interestController.animeIsOpen),
              buildCustomInterestTile(w, h, context,"Series",seriesNode, seriesEditingController, interestController.series,interestController.seriesIsOpen),
              buildCustomInterestTile(w, h, context,"Movies",movieNode, movieEditingController, interestController.movies,interestController.moviesIsOpen),
              buildCustomInterestTile(w, h, context,"Drama",dramaNode, dramaEditingController, interestController.dramaList,interestController.dramaIsOpen),
              buildCustomInterestTile(w, h, context,"Sports",sportsNode, sportsEditingController, interestController.sports,interestController.sportsIsOpen),
              // Accordion(
              //   maxOpenSections: 1,
              //     disableScrolling: true,
              //     children: [
              //       buildAccordionSection(context, h, w, "Anime", animeNode, animeEditingController, interestController.animeList),
              //       buildAccordionSection(context, h, w, "Series", seriesNode, seriesEditingController, interestController.series),
              //       buildAccordionSection(context, h, w, "Movies", movieNode, movieEditingController, interestController.movies),
              //       buildAccordionSection(context, h, w, "Drama", dramaNode, dramaEditingController, interestController.dramaList),
              //       buildAccordionSection(context, h, w, "Sports", sportsNode, sportsEditingController, interestController.sports),
              // ]),

            ],
          ),
        ),
      ),
    );
  }

  GetX<OnBoardingController> buildCustomInterestTile(double w, double h, BuildContext context, String hint,FocusNode node, TextEditingController editingController, RxList<String> interestList, RxBool isOpen) {
    return GetX<OnBoardingController>(
              builder: (ctrl) {
                if (!isOpen.value) {
                  return SizedBox(
                  width: w,
                  height: h*0.08,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                    child: InkWell(
                      onTap: (){
                        isOpen.value = !isOpen.value;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(hint,style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          )),
                          const Icon(Icons.keyboard_arrow_down,color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                );
                } else {
                  return Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15,top: 25),
                  child: Container(
                    width: w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.2))
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: h*0.05,
                          width: w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: InkWell(
                              onTap: (){
                                isOpen.value = !isOpen.value;
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(hint,style: Theme.of(context).textTheme.headline3!.copyWith(
                                    fontSize: 20,
                                    color: Colors.black,
                                  )),
                                  const Icon(Icons.keyboard_arrow_down,color: Colors.black,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: h*0.01,),
                        Column(
                          children: [
                            Container(
                              height:h*0.06,
                              width: w*0.8,
                              constraints: const BoxConstraints(
                                  maxHeight: double.infinity
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    fillColor: const Color(0xffFFF6F6),
                                    filled: true,
                                    hintText: "Add tag",
                                    suffixIcon: const Icon(Icons.add_circle,size: 30,),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            style: BorderStyle.none))),
                                textCapitalization: TextCapitalization.sentences,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                controller: editingController,
                                focusNode: node,
                                onFieldSubmitted: (text) {
                                  interestList.add(text);
                                  editingController.clear();
                                },
                              ),
                            ),

                            SizedBox(height: h*0.01,),
                            Wrap(
                                children: interestList.map((element) => Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Chip(
                                    label: Text(element),
                                    deleteIcon: const Icon(Icons.clear_rounded,size: 15,),
                                    onDeleted: (){
                                      interestList.remove(element);
                                    },
                                  ),
                                )
                                ).toList(),)


                          ],
                        ),
                      ],
                    ),
                  ),
                );
                }
              }
            );
  }

  AccordionSection buildAccordionSection(BuildContext context, double h, double w,String hint,FocusNode node,TextEditingController controller,RxList interestList) {
    return AccordionSection(
                  contentBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  contentBorderColor: Colors.transparent,
                  headerBackgroundColorOpened: Theme.of(context).primaryColor,
                  header: Text(hint,style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                  ),),

                  content: GestureDetector(
                    onTap: (){
                      node.unfocus();
                    },
                    child: Container(
                      height: h * 0.2,
                      width: w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            height:h*0.06,
                            width: w,
                            constraints: const BoxConstraints(
                                maxHeight: double.infinity
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: const Color(0xffFFF6F6),
                                  filled: true,
                                  hintText: "Add tag",
                                  suffixIcon: const Icon(Icons.add_circle,size: 30,),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none))),
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              controller: controller,
                              focusNode: node,
                              onFieldSubmitted: (text) {
                                interestList.add(text);
                                controller.clear();
                              },
                            ),
                          ),


                          Obx(() {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Wrap(
                                  children: interestList.map((element) => Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Chip(
                                      label: Text(element),
                                      deleteIcon: const Icon(Icons.clear_rounded,size: 15,),
                                      onDeleted: (){
                                        interestList.remove(element);
                                      },
                                    ),
                                  )
                                  ).toList(),),
                              ],
                            );
                          })

                        ],
                      ),
                    ),
                  ));
  }
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight*1.5,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: Themes.appBarGradient,
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(17),
                  bottomLeft: Radius.circular(17)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 0)
              ]),
        ),
        title: const Text("Let's get know you",style: TextStyle(
          fontSize: 27,
          color: Colors.white,
          fontWeight: FontWeight.normal
        ),),
      // centerTitle: true,
    );
  }
}
