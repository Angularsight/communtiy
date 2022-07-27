

import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/onboarding_controller.dart';
import 'new_ui/coupons_screen.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseController partyController = Get.find();
  final OnBoardingController userController = Get.put(OnBoardingController());

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late PageController pageController;
  int currentPage = 0;


  // bool queryComplete = false;
  // List<UserDetailsModel> userQueryImages = [];
  // List<PartyDetails> partyQueryImages = [];
  // int imagesLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0,viewportFraction: 0.8);
    pageController.addListener(() {
      int next = pageController.page!.round();
      if(currentPage!=next){
        setState(() {
          currentPage = next;
        });
      }
    });

  }



  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

          body: GestureDetector(
            onTap: (){
              searchFocusNode.unfocus();
              searchController.clear();
            },
            child: CustomScrollView(
              slivers: [
                // buildAppBar(context),
                buildHomeLocationBar2(context,w,h),
                SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      child: Column(
                        children:  [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: w * 0.06,vertical: h * 0.03),
                              child: SizedBox(
                                height: h*0.06,
                                child: TypeAheadField<PartyDetails?>(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: searchController,
                                    focusNode: searchFocusNode,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      focusColor: Colors.transparent,
                                      border:  OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              style: BorderStyle.none)),
                                      filled: true,
                                      fillColor: Theme.of(context).canvasColor,
                                      hintText: "Look up parties",
                                      contentPadding: EdgeInsets.symmetric(horizontal: w*0.02),
                                      hintStyle: Theme.of(context).textTheme.headline1!.copyWith(
                                          color: Colors.black.withOpacity(0.5)
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Color(0xff505050),
                                      ),
                                    )
                                  ),
                                    suggestionsBoxDecoration:  const SuggestionsBoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)
                                      ),
                                    ),
                                    suggestionsCallback: partyController.partyQuerySuggestions,
                                    itemBuilder: (context,PartyDetails? suggestions){
                                      return ListTile(
                                        leading: Container(
                                          height: w*0.1,
                                          width:w*0.1,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            image: DecorationImage(image: NetworkImage(suggestions!.images![0].toString()),fit: BoxFit.cover)
                                          ),
                                        ),
                                        title: Text("${suggestions.partyName}"),);
                                      },
                                    noItemsFoundBuilder: (context)=>Center(child:Text("Nothing found yet",style: Theme.of(context).textTheme.headline1,)),
                                    onSuggestionSelected: (PartyDetails? suggested){
                                    final partyIndex = partyController.parties.indexWhere((element) => element.partyName==suggested!.partyName);
                                      Get.to(()=>PartyDetails2(index: partyIndex,));
                                    }),
                                // child: TextField(
                                //   focusNode: searchFocusNode,
                                //   controller: searchController,
                                //   autocorrect: true,
                                //   autofocus: false,
                                //   showCursor: true,
                                //   decoration: InputDecoration(
                                //     focusColor: Colors.transparent,
                                //     border:  OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(7),
                                //         borderSide: const BorderSide(
                                //             color: Colors.transparent,
                                //             style: BorderStyle.none)),
                                //     filled: true,
                                //     fillColor: Theme.of(context).canvasColor,
                                //     hintText: "Dont think just look it up",
                                //     contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                //     hintStyle: Theme.of(context).textTheme.headline1!.copyWith(
                                //         color: Colors.black.withOpacity(0.5)
                                //     ),
                                //     prefixIcon: const Icon(
                                //       Icons.search,
                                //       color: Color(0xff505050),
                                //     ),
                                //   ),
                                //   onEditingComplete: () async {
                                //     Future.wait([
                                //       partyController.searchQueryUser(searchController.text).then((value) {
                                //         queryComplete = true;
                                //         searchFocusNode.unfocus();
                                //         userQueryImages = value;
                                //         print('user details : ${userQueryImages}');
                                //       }),
                                //       partyController.searchQueryParty(searchController.text).then((value) {
                                //         queryComplete = true;
                                //         searchFocusNode.unfocus();
                                //         partyQueryImages = value;
                                //         print('party details : ${partyQueryImages}');
                                //       })
                                //     ]);
                                //   },
                                // ),
                              )
                          ),

                          GetX<FirebaseController>(
                            builder: (FirebaseController partyController) {
                              return SizedBox(
                                width: double.infinity,
                                height: h*0.55,
                                child: PageView.builder(
                                    controller: pageController,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: partyController.parties.length,
                                    itemBuilder: (context,index){
                                      bool isActive = (index==currentPage);
                                      try{
                                        return pageViewCard(index, isActive,h);
                                      }catch(e){
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: w*0.02),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              height: h*0.45,
                                              width: w*0.9,
                                              color: const Color(0xff414141),
                                              child: Shimmer.fromColors(
                                                baseColor: const Color(0xff2d2d2d),
                                                highlightColor: const Color(0xff6a737c),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top: h*0.4,left: w*0.008,right: w*0.008),
                                                      child: Container(
                                                        width: w * 0.4,
                                                        height: h*0.03,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: h*0.025,),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: h*0.03,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      // return pageViewCard(index,isActive);
                                    }),
                              );
                            }
                          ),

                          // const SizedBox(height: 25,),

                        ],
                      ),
                    )
                )
              ],
            ),
          )

      ),
    );
  }


  Widget pageViewCard(int index, bool isActive, double h) {
    // final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    double paddingTop = isActive?0:h*0.045;
    // double containerHeight = isActive?150:100;

    return InkWell(
      onTap: (){
        Get.to(() =>  PartyDetails2(index:currentPage));
      },
      child:AnimatedPadding(
        duration: const Duration(milliseconds: 500),
        padding: EdgeInsets.only(top: paddingTop,right: h*0.02),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              SizedBox(
                height: h*0.55,
                // duration: const Duration(milliseconds: 400),
                child:partyController.parties[index].images![0]!=null?
                Image.network(partyController.parties[index].images![0].toString(),fit: BoxFit.cover,)
                    : Image.asset("assets/images/default profile image.png"),
              ),
              Padding(
                padding: EdgeInsets.only(top: h*0.43),
                child: Container(
                  height: h*0.12,
                  decoration: BoxDecoration(
                      gradient: Themes.softBlackGradient
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(partyController.parties[index].partyName.toString(),style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: Colors.white
                          ),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(partyController.parties[index].time.toString(),style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white),),
                          Text(partyController.parties[index].location.toString(),style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white),),
                          Text("Rs.${partyController.parties[index].entryFee}",style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white),),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }

  Widget buildHomeLocationBar2(BuildContext context, double w,double h) {

    return GetX<OnBoardingController>(
      // init: Get.put(OnBoardingController()),
      builder: (userController) {
        // userController.userProfile.bindStream(userController.connectUserToApp());
        // final profilePic = userController.userProfile.value.userProfilePic;
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06,vertical: h * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on_rounded,color: Theme.of(context).canvasColor,size: 30,),
                SizedBox(width: w*0.01,),
                // const SizedBox(width: 5,),
                Expanded(
                  child: InkWell(
                    onTap: (){},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Home",style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.white,
                            fontSize: 18
                        ),),
                        userController.userProfile.value.location!=null?Text(userController.userProfile.value.location.toString(),
                          style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: const Color(0xffB6B6B6),
                            fontSize: 12
                        ),):Text("Somewhere on earth",style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: const Color(0xffB6B6B6),
                            fontSize: 12
                        ),),
                      ],
                    ),
                  ),
                ),

                Icon(Icons.notifications_none,color: Theme.of(context).canvasColor,size: 30,),
                SizedBox(width: w*0.03,),
                Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: ()async{
                      var couponImages = await userController.fetchCouponImages();
                      var discountAndImages = await userController.fetchDiscountAndImages();
                      Get.to(()=>CouponsScreen(couponImages: couponImages, discountAndImage: discountAndImages,));
                    },
                    child: ClipOval(
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        radius: w*0.042,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/Drinks with wings 7.png'),
                              fit: BoxFit.contain,
                            )
                          ),
                        )
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }




}


