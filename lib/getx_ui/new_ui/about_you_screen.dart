

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_details/interests.dart';

class AboutYouScreen extends StatefulWidget {
  Interests interests;
  AboutYouScreen({Key? key,required this.interests}) : super(key: key);

  @override
  State<AboutYouScreen> createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends State<AboutYouScreen> with TickerProviderStateMixin{
  final OnBoardingController userController = Get.find();
  late TabController _tabController;

  final TextEditingController interestController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  final FocusNode interestNode = FocusNode();
  final FocusNode ageNode = FocusNode();
  final FocusNode phoneNoNode = FocusNode();

  ///For Chips Choice
  List<int> selectedOption = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    const dummyImage = 'https://bestprofilepictures.com/wp-content/uploads/2021/07/Dope-Profile-Picture.jpg';
    final user = userController.userProfile.value;
    // fetchInterest();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: h*0.3,
              width: w,
              decoration: const BoxDecoration(
                image: DecorationImage(image: NetworkImage(dummyImage),fit: BoxFit.cover)
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2,sigmaY: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.0)
                  ),
                )
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: h*0.25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        radius: w*0.15,
                        child: CircleAvatar(
                          radius: w*0.15-5,
                          child: ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(user.userProfilePic.toString()),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height:h*0.01),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(user.userName.toString(),style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.white
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${user.userId}",style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15
                      ),),
                      const SizedBox(width: 5,),
                      const Icon(Icons.copy,color: Colors.blue,size: 20,)
                    ],
                  ),
                  SizedBox(height: h*0.025,),

                  SizedBox(
                    width: w,
                    height: h*0.05,
                    child: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.white,
                        indicatorWeight: 0,

                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: _tabController,
                        tabs: const [
                          Tab(text: "Basics",),
                          Tab(text: "Interests",)
                        ]
                    ),
                  ),

                  // _tabController.index==0?basicsTab(w, h, user):interestsTab(w, h)

                  SizedBox(
                    width: w,
                    height: h*0.55,
                    child: TabBarView(
                        controller: _tabController,
                        children: [
                          basicsTab(w, h, user),
                          interestsTab(w, h)
                        ]),
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget basicsTab(double w,double h,UserDetailsModel user){
    var t1 = Theme.of(context).textTheme.headline1;
    final address = user.location!.split(',');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:w*0.02,vertical: h*0.02),
      child: Column(
        children: [
          SizedBox(
            /// Same height as images in guest list
            height: w*0.6,
            width: w,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context,index)=>SizedBox(width: w*0.02,),
                itemCount: user.images!.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onLongPress: (){
                        /// TODO: Replacing image in firestore via cloud storage with image compression
                      },
                      child: Container(
                        width: w*0.4,
                        // height: h*0.2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(user.images![index]),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(height: h*0.02,),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Info",style:  t1!.copyWith(
                  color: Colors.white,
                  fontSize: 25
              )),
              SizedBox(width: w*0.02,),
            ],
          ),
          SizedBox(height: h*0.005,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location",style: t1.copyWith(
                    color: Colors.white,
                    fontSize: 18
                  ),),
                  SizedBox(
                    // width: w*0.23,
                    height: h*0.1,
                    child: Text('${address[0]}\n${address[1]}',style:t1.copyWith(
                      color:const Color(0xffDFA91D),
                      fontSize: 14
                    )),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Age",style: t1.copyWith(
                      color: Colors.white,
                      fontSize: 18
                  ),),
                  SizedBox(
                    // width: w*0.23,
                    height: h*0.1,
                    child: Text(user.age.toString(),style:t1.copyWith(
                        color:Colors.white,
                        fontSize: 14
                    )),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phone",style: t1.copyWith(
                      color: Colors.white,
                      fontSize: 18
                  ),),
                  SizedBox(
                    // width: w*0.23,
                    height: h*0.1,
                    child: Text(user.phoneNumber.toString(),style:t1.copyWith(
                        color:const Color(0xff61FF00),
                        fontSize: 14
                    )),
                  )
                ],
              )
            ],
          )
        ]
      )
    );
  }

  Widget interestsTab(w,h){
    var userInterests = widget.interests;
    List<String> permanentInterests = ['Anime','Drama','Movies','Series','Sports'];

    List<String> missingInterests = [];
    int itemCount = 0;
    List<String> variables= [];
    List<List?> variablesList = [];
    if(userInterests.anime!.isNotEmpty){
      itemCount+=1;
      variables.add('Anime');
      variablesList.add(userInterests.anime);
    }

    if(userInterests.drama!.isNotEmpty){
      itemCount+=1;
      variables.add("Drama");
      variablesList.add(userInterests.drama);
    }

    if(userInterests.movies!.isNotEmpty){
      itemCount+=1;
      variables.add("Movies");
      variablesList.add(userInterests.movies);
    }

    if(userInterests.series!.isNotEmpty){
      itemCount+=1;
      variables.add("Series");
      variablesList.add(userInterests.series);
    }

    if(userInterests.sport!.isNotEmpty){
      itemCount+=1;
      variables.add("Sports");
      variablesList.add(userInterests.sport);
    }

    ///Adding missing interests to missing interests list for new addition of interests
    for(String element in permanentInterests){
      if(!variables.contains(element)){
        missingInterests.add(element);
      }
    }

    // print("Variables length:${variables.length}");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal:w*0.02,vertical: h*0.02),
      child: Column(
        children: [
          SizedBox(
            height: h*0.04,
            width: w,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context,index)=>SizedBox(width: w*0.02,),
                itemCount: permanentInterests.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: ()async{
                      if(missingInterests.contains(permanentInterests[index])){
                        int fieldIndex = missingInterests.indexOf(permanentInterests[index]);
                        String field = missingInterests[fieldIndex];
                        await updateInterest(field, ['']);
                      }
                    },
                    child: Container(
                      width: w*0.2,
                      height: 40,
                      decoration: BoxDecoration(
                        color: variables.contains(permanentInterests[index])?Theme.of(context).canvasColor:Colors.grey,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text(permanentInterests[index],style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.black,
                        fontSize: 16
                      ),),),
                    ),
                  );
                }),
          ),

          SizedBox(height: h*0.01,),

          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: variables.length,
              itemBuilder: (context,mainIndex){
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: w,
                    height: h*0.07,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: w*0.02,top: 3,right:w*0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(variables[mainIndex],style: Theme.of(context).textTheme.headline1!.copyWith(
                                color: Colors.white,
                                fontSize: 16
                              ),),
                              InkWell(
                                  onTap: (){
                                    openInterestEditDialogBox(context,variables[mainIndex],variablesList[mainIndex],w,h);
                                  },
                                  child: const Icon(Icons.edit,color: Colors.white,size: 20,))
                            ],
                          ),
                          SizedBox(
                            height: h*0.025,
                            width: w*0.8,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: variablesList[mainIndex]!.length,
                                itemBuilder: (context,index){
                                  return Text("${variablesList[mainIndex]![index]} , ",style:Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Colors.white,
                                      fontSize: 14
                                  ),);
                                }),
                          )

                        ],
                      ),
                    ),
                  ),
                );
              })

        ],
      ),
    );
  }

  openInterestEditDialogBox(BuildContext context,String variable, List<dynamic>? variablesList,double w,double h) {

    ///Converting dynamic list to string list
    List<String> newInterestList = [];
    List<String> editedInterestList = [];
    String primaryTextForController = '';
    for (var element in variablesList!) {
      primaryTextForController+= element.toString()+',';
      newInterestList.add(element.toString());
    }
    editedInterestList = newInterestList;
    interestController.text = primaryTextForController;

    showDialog(
        context: context,
        builder: (context){
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 3,sigmaX: 3),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: SizedBox(
                width: w,
                height: h*0.25,
                child: Padding(
                  padding: EdgeInsets.all(w*0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(variable,style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.white,
                        fontSize: 22
                      ),),
                      // SizedBox(height: h*0.01,),
                      Text("Enter values separated by commas",style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Colors.grey,
                          fontSize: 14
                      ),),
                      SizedBox(height: h*0.01,),
                      SizedBox(
                        width: w * 0.7,
                        child: TextFormField(
                          decoration: InputDecoration(

                              fillColor: const Color(0xff5b5b5b),
                              filled: true,
                              hintText: 'Interests',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none))),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          key: const ValueKey('interestEdit'),
                          controller: interestController,
                          focusNode: interestNode,
                          onFieldSubmitted: (String text){
                            editedInterestList = text.split(',');
                            // print("Interest List After edit : $editedInterestList ");
                          },
                        ),
                      ),
                      // SizedBox(height: h*0.02,),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: ()async{
                              editedInterestList.remove('');
                              if(editedInterestList==newInterestList){
                                Navigator.pop(context);
                              }else{
                               // print("Not same:$editedInterestList , $newInterestList");
                               await updateInterest(variable, editedInterestList);
                               Navigator.pop(context);
                              }
                            },
                            child: Text("Done",style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: Colors.white,
                              fontSize: 18
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );

  }



  readFromInterest()async{
    var newInterest = await FirebaseFirestore.instance.collection("Interests").where('userId',isEqualTo: userController.userProfile.value.userId).get().then((querySnapshot) {
      var result = querySnapshot.docs.map((doc) => Interests.fromDocument(doc)).toList();
      return result[0];
    });

    setState(() {
      widget.interests = newInterest;
    });

  }

  updateInterest(String field,List<dynamic> value)async{
    var doc = await FirebaseFirestore.instance.collection('Interests').where('userId',isEqualTo: userController.userProfile.value.userId).get();
    var docId = doc.docs[0].id;

    ///Updating doc
    await FirebaseFirestore.instance.collection("Interests").doc(docId).update({
      field.toLowerCase():value
    });

    ///Calling read to refresh the UI
    await readFromInterest();

  }



}






