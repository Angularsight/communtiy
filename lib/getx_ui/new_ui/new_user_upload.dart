

import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:steps_indicator/steps_indicator.dart';

class NewUserUpload extends StatefulWidget {
  const NewUserUpload({Key? key}) : super(key: key);

  @override
  _NewUserUploadState createState() => _NewUserUploadState();
}

class _NewUserUploadState extends State<NewUserUpload> {

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController petController = TextEditingController();
  final TextEditingController _pinPutController = TextEditingController();


  final FocusNode _pinNode = FocusNode();
  late FocusNode userNameNode;
  late FocusNode ageNode;
  late FocusNode locationNode;
  late FocusNode occupationNode;
  late FocusNode heightNode;
  late FocusNode petNode;

  String username = '';
  String age = '';
  String location = '';
  String occupation = '';
  String height = '';
  String pet = "";
  String _radioValue = 'Single';

  List<String> chipSelectList = [];
  final TextEditingController interestEditingController = TextEditingController();
  final interestOptions = ['Anime','Sports','Drama','Movies','Series',];
  int interestOptionSelected  = 0;

  int selectedStep = 0;
  final pageController = PageController(keepPage: false);

  File? pickedImage2;
  bool pickedImageBool2 = false;
  List<File> imageList2 = [];
  int photoIndex2 = 0;
  final urlList2 = [];
  final userProfilePicUrlList = [];
  void _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(selectedImage!.path);

    setState(() {
      pickedImageBool2 = true;
      pickedImage2 = pickedImageFile;
      imageList2.add(pickedImageFile);
      photoIndex2 = imageList2.length - 1;
    });
  }

  bool userImagePickedBool = false;
  List<File> userProfilePic = [];
  void _pickDJImage() async {
    final imagePicker = ImagePicker();
    final selectedImage =
    await imagePicker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(selectedImage!.path);

    setState(() {
      userImagePickedBool = true;
      pickedImage2 = pickedImageFile;
      userProfilePic.add(pickedImageFile);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameNode = FocusNode();
    ageNode = FocusNode();
    locationNode = FocusNode();
    occupationNode = FocusNode();
    heightNode = FocusNode();
    petNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {

    var w = MediaQuery.of(context).size.width;
    var borderColor = Theme.of(context).primaryColor;
    var unselectedColor = const Color(0xff778D94);
    var h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          gradient: Themes.logoGradient
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Container(
          height: h*0.06,
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  Get.offAll(()=>BottomNavigationPage());
                },
                child: Container(
                  width: w*0.5,
                  decoration: const BoxDecoration(
                    color: Color(0xff778D94)
                  ),
                  child: const Center(child: Text("Skip for now",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xff393939),
                    fontSize: 16
                  ),),),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    if(selectedStep<2){
                      selectedStep = selectedStep+1;
                      pageController.animateToPage(selectedStep, duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
                    }else if(selectedStep==2){
                      Get.offAll(()=>BottomNavigationPage());
                    }
                  });
                },
                child: Container(
                  width: w*0.5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor
                  ),
                  child:Center(child: selectedStep<2?const Text("Next",style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff393939),
                      fontSize: 16
                  )):const Text("Done",style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff393939),
                      fontSize: 16
                  )),),
                ),
              )
            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: h*0.08,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: w*0.08,),
                  Column(
                    children: [
                      CircleAvatar(radius:15,backgroundColor: borderColor,child: CircleAvatar(radius:13,backgroundColor: const Color(0xff204D5B),child: Icon(Icons.person_outline,color: borderColor,size: 25,))),
                      const SizedBox(height: 2,),
                      Text("About you",style: TextStyle(
                          fontSize: 12,
                          color: borderColor
                      ),)
                    ],
                  ),
                  SizedBox(width: w*0.23,),
                  Column(
                    children: [
                      selectedStep>0?Icon(Icons.insert_chart_outlined,color: borderColor,size: 25,):
                      Icon(Icons.insert_chart_outlined,color: unselectedColor,size: 25,),
                      const SizedBox(height: 2,),
                      selectedStep>0?Text("Status",style: TextStyle(
                          fontSize: 12,
                          color: borderColor
                      ),):Text("Status",style: TextStyle(
                          fontSize: 12,
                          color: unselectedColor
                      ),)
                    ],
                  ),
                  SizedBox(width: w*0.23,),
                  Column(
                    children: [
                      selectedStep>1?Icon(Icons.star_border_outlined,color: borderColor,size: 25,):
                      Icon(Icons.star_border_outlined,color: unselectedColor,size: 25,),
                      const SizedBox(height: 2,),
                      selectedStep>1?Text("Interests",style: TextStyle(
                          fontSize: 12,
                          color: borderColor
                      ),):Text("Interests",style: TextStyle(
                          fontSize: 12,
                          color: unselectedColor
                      ),)
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10,),
              StepsIndicator(
                nbSteps: 3,
                selectedStep: selectedStep,
                selectedStepColorOut: borderColor,
                selectedStepColorIn: borderColor,
                doneStepColor: borderColor,
                doneLineColor: borderColor,
                undoneLineColor: unselectedColor,
                isHorizontal: true,
                lineLength: w*0.32,
                unselectedStepSize: 12,
                selectedStepSize: 10,

                // These two are border colors
                unselectedStepColorIn: unselectedColor,
                unselectedStepColorOut: unselectedColor,
                // enableLineAnimation: true,
                // enableStepAnimation: true,

              ),

              const SizedBox(height: 20,),
              SizedBox(
                width: w,
                height: h*0.7,
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildYou(w,h),
                    buildStatus(w,h),
                    buildInterests(w,h),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildYou(double w,double h){
    const t1 = TextStyle(
                    color: Color(0xffD3D3D3),
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  );
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding:EdgeInsets.only(left: w*0.05,top: h*0.03,right: w*0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tell us about yourself",style: TextStyle(
              fontSize: 20,
              color: Color(0xffD3D3D3),
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black,
                  offset: Offset(0,4),
                  blurRadius: 2
                )
              ]
            ),),
            SizedBox(height: h*0.03,),
            const Text("Add Pics",style: TextStyle(
              color: Color(0xffD3D3D3),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),),
            SizedBox(height: h*0.01,),
            pickedImageBool2
                ? afterImagePick()
                : Container(
              width: w*0.9,
              height: h * 0.3,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.4)),
                        child: const Center(
                          child: Text(
                            "+",
                            style: TextStyle(
                                fontSize: 35, color: Colors.white),
                          ),
                        )),
                  )),
            ),
            SizedBox(height: h*0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name",style: t1,),
                    const SizedBox(height: 2,),
                    SizedBox(
                      width: w * 0.58,
                      child: TextFormField(
                        decoration: InputDecoration(

                            fillColor: const Color(0xff838383),
                            filled: true,
                            hintText: 'Aadhar card name',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    style: BorderStyle.none))),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        key: const ValueKey('username'),
                        controller: userNameController,
                        focusNode: userNameNode,
                        onFieldSubmitted: (text) {
                          username = text;
                          FocusScope.of(context).requestFocus(ageNode);
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Age",style: t1,),
                    const SizedBox(height: 2,),
                    SizedBox(
                      width: w * 0.3,
                      child: TextFormField(
                        decoration: InputDecoration(
                            fillColor: const Color(0xff838383),
                            filled: true,
                            hintText: 'Ex:24',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    style: BorderStyle.none))),
                        textInputAction: TextInputAction.next,
                        keyboardType:
                        const TextInputType.numberWithOptions(
                            decimal: true),

                        key: const ValueKey('Age'),
                        controller: ageController,
                        focusNode: ageNode,
                        // onEditingComplete: ()=>Focus.of(context).requestFocus(locationNode),
                        onFieldSubmitted: (text) {
                          age = text;
                          FocusScope.of(context).requestFocus(locationNode);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8,),
            const Text("Home Location",style: t1,),
            const SizedBox(height: 2,),
            SizedBox(
              width: w * 0.8,
              child: TextFormField(
                decoration: InputDecoration(
                    fillColor: const Color(0xff838383),
                    filled: true,
                    hintText: 'Ex:24',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    suffixIcon: const Icon(Icons.location_on_outlined,color: Color(0xffD3D3D3),),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            style: BorderStyle.none))),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                key: const ValueKey('Location'),
                controller: locationController,
                focusNode: locationNode,
                // onEditingComplete: ()=>Focus.of(context).requestFocus(locationNode),
                onFieldSubmitted: (text) {
                  location = text;
                  // FocusScope.of(context).requestFocus(locationNode);
                },
              ),
            ),

            SizedBox(height: h*0.02,),
            Text(
              "Pick profile pic",
              style: t1.copyWith(
                fontSize: 17
              )
            ),
            const SizedBox(height: 10,),
            Center(child: afterImagePick2()),
            const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }

  Widget buildStatus(double w,double h){

    const t1 = TextStyle(
        color: Color(0xffD3D3D3),
        fontWeight: FontWeight.w500,
        fontSize: 16
    );

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff838383)
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(8),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Padding(
      padding:EdgeInsets.only(left: w*0.05,top: h*0.03,right: w*0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What's your status?",style: TextStyle(
              fontSize: 20,
              color: Color(0xffD3D3D3),
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    color: Colors.black,
                    offset: Offset(0,4),
                    blurRadius: 2
                )
              ]
          )),
          const SizedBox(height: 20,),
          const Text("Relationship status",style: t1,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RadioButton(
                  activeColor: Theme.of(context).primaryColor,
                  description: "Single",
                  value: "Single",
                  textStyle: t1.copyWith(
                    color: Colors.white
                  ),
                  groupValue: _radioValue,
                  onChanged: (String? val){
                    setState(() {
                      _radioValue = val!;
                    });
                  }),
              const SizedBox(width: 10,),
              RadioButton(
                  activeColor: Theme.of(context).primaryColor,
                  description: "Taken",
                  value: "Taken",
                  textStyle: t1.copyWith(
                      color: Colors.white
                  ),
                  groupValue: _radioValue,
                  onChanged: (String? val){
                    setState(() {
                      _radioValue = val!;
                    });
                  }),
            ],
          ),
          const SizedBox(height: 8,),
          const Text("Occupation",style: t1,),
          const SizedBox(height: 5,),
          SizedBox(
            width: w * 0.8,
            child: TextFormField(
              decoration: InputDecoration(
                  fillColor: const Color(0xff838383),
                  filled: true,
                  hintText: 'Ex: Android developer,student....',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          style: BorderStyle.none))),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              key: const ValueKey('Occupation'),
              controller: occupationController,
              focusNode: occupationNode,
              // onEditingComplete: ()=>Focus.of(context).requestFocus(locationNode),
              onFieldSubmitted: (text) {
                occupation = text;
                FocusScope.of(context).requestFocus(heightNode);
              },
            ),
          ),

          const SizedBox(height: 15,),
          const Text("Height",style: t1,),
          const SizedBox(height: 10,),

          Pinput(
            closeKeyboardWhenCompleted: true,
            length: 2,
            separator: const SizedBox(
              width: 25,
              height: 50,
              child: Center(child: Text(":",style: TextStyle(
                color: Colors.white,
                fontSize: 32
              ),),),
            ),
            keyboardType: TextInputType.number,
            showCursor: false,
            focusNode: _pinNode,
            textInputAction: TextInputAction.none,
            controller: _pinPutController,
            onCompleted: (String pin)async{
            },
            submittedPinTheme: submittedPinTheme,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
          ),

          const SizedBox(height: 15,),
          const Text("Favorite Pet",style: t1,),
          const SizedBox(height: 5,),
          SizedBox(
            width: w * 0.8,
            child: TextFormField(
              decoration: InputDecoration(
                  fillColor: const Color(0xff838383),
                  filled: true,
                  hintText: 'Ex:Cat,dog,parrot...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          style: BorderStyle.none))),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              key: const ValueKey('Pet'),
              controller: petController,
              focusNode: petNode,
              // onEditingComplete: ()=>Focus.of(context).requestFocus(locationNode),
              onFieldSubmitted: (text) {
                pet = text;
                FocusScope.of(context).unfocus();
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget buildInterests(double w,double h){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding:EdgeInsets.only(left: w*0.05,top: h*0.03,right: w*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tell us about your interests",style: TextStyle(
                fontSize: 20,
                color: Color(0xffD3D3D3),
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                      color: Colors.black,
                      offset: Offset(0,4),
                      blurRadius: 2
                  )
                ]
            )),
            SizedBox(height: h*0.02,),
            Container(
              width: w,
              height: h*0.45,
              decoration: BoxDecoration(
                gradient: Themes.transparentGradient,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      width: w*0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffCDC850)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Tell us about your favorite THING",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            width: w*0.8,
                            height: h*0.23,
                            decoration: const BoxDecoration(
                              color: Color(0xff1A3841),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: h * 0.06,
                                    width: w * 0.8,
                                    child: TextFormField(
                                      autocorrect: true,
                                      decoration: InputDecoration(
                                          fillColor: const Color(0xffFFF6F6),
                                          filled: true,
                                          hintText: "Add tag",
                                          suffixIcon:  InkWell(
                                            onTap: (){
                                              setState(() {
                                                chipSelectList.add(interestEditingController.text);
                                                interestEditingController.clear();
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add_circle,
                                              size: 30,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide:
                                              const BorderSide(style: BorderStyle.none))),
                                      textCapitalization: TextCapitalization.sentences,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name,
                                      controller: interestEditingController,
                                      // focusNode: node,
                                      onFieldSubmitted: (text){
                                        setState(() {
                                          chipSelectList.add(text);
                                          interestEditingController.clear();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Wrap(
                                    children: chipSelectList
                                        .map((element) => Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Chip(
                                        label: Text(element),
                                        backgroundColor: const Color(0xffE3D170),
                                        deleteIcon: const Icon(
                                          Icons.clear_rounded,
                                          size: 15,
                                        ),
                                        onDeleted: () {
                                          setState(() {
                                            chipSelectList.remove(element);
                                          });

                                        },
                                      ),
                                    ))
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                    ),
                    const SizedBox(height: 10,),
                    ChipsChoice<int>.single(
                      padding: EdgeInsets.zero,
                      value: interestOptionSelected,
                      wrapped: true,
                      onChanged: (val) {
                        setState(() {
                          interestOptionSelected = val;
                        });
                      },
                      choiceItems: C2Choice.listFrom<int, String>(
                        source: interestOptions,
                        value: (i, v) => i,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                      choiceStyle: C2ChoiceStyle(
                        // color: Colors.blue,
                        showCheckmark: true,
                        disabledColor: Colors.transparent,
                        labelStyle: const TextStyle(fontSize: 12,color: Colors.black), borderShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: Theme.of(context).primaryColor))

                      ),
                    //
                    //   choiceActiveStyle: C2ChoiceStyle(
                    //       brightness: Brightness.dark,
                    //       color: Theme.of(context).primaryColor,
                    //       borderShape: RoundedRectangleBorder(
                    //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                    //           side: BorderSide(color: Theme.of(context).primaryColor)),
                    //       labelStyle: const TextStyle(fontSize: 12, color: Colors.black),
                    // ),

                    )


                  ],
                ),
              ),
            ),

            SizedBox(height: h*0.03,),
            const Text("Your Interests",style: TextStyle(
                fontSize: 20,
                color: Color(0xffD3D3D3),
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                      color: Colors.black,
                      offset: Offset(0,4),
                      blurRadius: 2
                  )
                ]
            )),

            const SizedBox(height: 5,),
            SizedBox(
              width: w,
              height: h*0.2,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                  itemCount: 1,
                  itemBuilder: (context,index){
                    return buildInterestListContainer(w,h,index);
                  }),
            )

          ],
        ),
      ),
    );
  }

  Widget afterImagePick() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: w * 0.6,
          height: h * 0.3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              imageList2[photoIndex2],
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                _pickImageFromGallery();
              },
              child: Container(
                height: h * 0.06,
                width: h * 0.15,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5)),
                child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 25,
                      color: Colors.white,
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: w * 0.3,
              height: h * 0.23,
              child: ListView.builder(
                  itemCount: imageList2.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            photoIndex2 = index;
                          });
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  imageList2[index],
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ));
                  }),
            ),
          ],
        )
      ],
    );
  }

  Widget afterImagePick2() {
    final w = MediaQuery.of(context).size.width;
    // final h = MediaQuery.of(context).size.height;

    if (userImagePickedBool) {
      return SizedBox(
        width: w * 0.6,
        height: w * 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            userProfilePic[0],
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: w * 0.65,
        height: w * 0.55,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: InkWell(
              onTap: () {
                _pickDJImage();
              },
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.4)),
                  child: const Center(
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  )),
            )),
      );
    }
  }

  Widget buildInterestListContainer(double w, double h,int index) {
    var description = '';
    for (var element in chipSelectList) {
      description+=element+', ';
    }
    return Container(
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: Themes.transparentGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(interestOptions[interestOptionSelected],style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),),
            Text(description,style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),)
          ],
        ),
      ),
    );

  }

}