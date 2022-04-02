import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/getx_ui/interest_upload.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserUpload extends StatefulWidget {
  UserUpload({Key? key}) : super(key: key);

  @override
  State<UserUpload> createState() => _UserUploadState();
}

class _UserUploadState extends State<UserUpload> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController xpController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late FocusNode userNameNode;
  late FocusNode ageNode;
  late FocusNode locationNode;
  late FocusNode xpNode;
  late FocusNode phoneNumberNode;
  late FocusNode passwordNode;

  String username = '';
  String age = '';
  String location = '';
  String xp = '';
  String password = '';
  String phoneNumber = "";

  final OnBoardingController onBoardingController = Get.put(OnBoardingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameNode = FocusNode();
    ageNode = FocusNode();
    locationNode = FocusNode();
    xpNode = FocusNode();
    phoneNumberNode = FocusNode();
    passwordNode = FocusNode();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userNameNode.dispose();
    ageNode.dispose();
    locationNode.dispose();
    xpNode.dispose();
    phoneNumberNode.dispose();
  }

  File? pickedImage2;
  bool pickedImageBool2 = false;
  List<File> imageList2 = [];
  int photoIndex2 = 0;
  final urlList2 = [];
  final userProfilePicUrlList = [];
  void _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(selectedImage!.path);

    setState(() {
      pickedImageBool2 = true;
      pickedImage2 = pickedImageFile;
      imageList2.add(pickedImageFile);
      photoIndex2 = imageList2.length - 1;
    });
  }

  ///Activity and special Appearance
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

  void _prepareDataForFirebase() async {
    int i = 1;
    for (int j = 0; j < imageList2.length; j++) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("users")
          .child(username)
          .child(username + i.toString() + '.jpg');
      await ref.putFile(imageList2[j]).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlList2.add(value);
        });
      });
      i += 1;
    }

    print(urlList2);

    final ref2 = FirebaseStorage.instance.ref().child('users').child(username).child('profile pic').child(username+'.jpg');
    await ref2.putFile(userProfilePic[0]).whenComplete(() async {
      await ref2.getDownloadURL().then((value) {
        userProfilePicUrlList.add(value);
      });
    });

    print("Profile pic url :$userProfilePicUrlList");
    _uploadDataToFirebase();
  }

  void _uploadDataToFirebase() {
    FirebaseFirestore.instance.collection('UserDetails').doc().set({
      'userId':'something',
      'userName':username,
      'password':password,
      'userProfilePic':userProfilePicUrlList[0],
      'phoneNumber':int.parse(phoneNumber),
      'location':location,
      'age':int.parse(age),
      'xp':int.parse(xp),
      'images':urlList2
    });
  }


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pickedImageBool2
                          ? afterImagePick()
                          : Container(
                              width: w,
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: w * 0.58,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: const Color(0xffFFF6F6),
                                  filled: true,
                                  hintText: 'Your name',
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
                          SizedBox(
                            width: w * 0.3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: const Color(0xffFFF6F6),
                                  filled: true,
                                  hintText: 'Age',
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
                                FocusScope.of(context)
                                    .requestFocus(locationNode);
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: w * 0.58,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: const Color(0xffFFF6F6),
                                  suffixIcon:
                                      const Icon(Icons.location_on_outlined),
                                  filled: true,
                                  hintText: 'Location',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none))),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              key: const ValueKey('Location'),
                              controller: locationController,
                              focusNode: locationNode,
                              onFieldSubmitted: (text) {
                                location = text;
                                FocusScope.of(context).requestFocus(xpNode);
                              },
                            ),
                          ),
                          SizedBox(
                            width: w * 0.3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: const Color(0xffFFF6F6),
                                  suffixIcon: const Icon(Icons.star_outline),
                                  filled: true,
                                  hintText: 'Xp',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none))),
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false),
                              key: const ValueKey('Xp'),
                              controller: xpController,
                              focusNode: xpNode,
                              onFieldSubmitted: (text) {
                                xp = text;
                                FocusScope.of(context).requestFocus(phoneNumberNode);
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: w,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: const Color(0xffFFF6F6),
                              suffixIcon:
                                  const Icon(Icons.phone_android_rounded),
                              filled: true,
                              hintText: 'Phone Number',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none))),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          key: const ValueKey('phone number'),
                          controller: phoneNumberController,
                          focusNode: phoneNumberNode,
                          onFieldSubmitted: (text){
                            phoneNumber = text;
                            FocusScope.of(context).requestFocus(passwordNode);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: w,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: const Color(0xffFFF6F6),
                              filled: true,
                              hintText: "Password",
                              suffixIcon: const Icon(Icons.password),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none))),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          key: const ValueKey('password'),
                          controller: passwordController,
                          focusNode: passwordNode,
                          onFieldSubmitted: (text) {
                            password = text;
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Pick profile pic",
                        style: t.textTheme.headline1!.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Center(child: afterImagePick2()),
                      const SizedBox(
                        height: 20,
                      ),


                      // InterestsUpload(listName: "Anime",interestList: onBoardingController.animeList,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              print('User name:$username , age:$age , Location :$location , Xp:$xp, phoneNumber:$phoneNumber , password:$password');
                              _prepareDataForFirebase();
                            },
                            child: Container(
                              width: w * 0.3,
                              height: h * 0.05,
                              decoration: BoxDecoration(
                                  color: t.primaryColor,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Center(
                                  child: Text(
                                "Upload",
                                style: t.textTheme.headline1!
                                    .copyWith(color: Colors.black),
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(()=>InterestsUpload());
                            },
                            child: Container(
                              width: w * 0.3,
                              height: h * 0.05,
                              decoration: const BoxDecoration(
                                  color: Color(0xffefd151),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Center(
                                  child: Text(
                                    "Next",
                                    style: t.textTheme.headline1!
                                        .copyWith(color: Colors.black),
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              userNameController.clear();
                              ageController.clear();
                              locationController.clear();
                              xpController.clear();
                              phoneNumberController.clear();
                              imageList2.clear();
                              urlList2.clear();
                              userProfilePic.clear();
                              userProfilePicUrlList.clear();
                              passwordController.clear();
                              setState(() {
                                pickedImageBool2 = false;
                                userImagePickedBool = false;
                              });
                            },
                            child: Container(
                              width: w * 0.3,
                              height: h * 0.05,
                              decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Center(
                                  child: Text(
                                "Clear all",
                                style: t.textTheme.headline1!
                                    .copyWith(color: Colors.black),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ],
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
              height: h * 0.3,
              child: ListView.builder(
                  itemCount: imageList2.length,
                  itemBuilder: (context, index) {
                    return InkWell(
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
            width: w * 0.5,
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
            width: w * 0.5,
            height: w * 0.5,
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
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
      title: Padding(
        padding: EdgeInsets.only(left: Get.width * 0.15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  Text(
                    "Community",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = Colors.black),
                  ),
                  Text(
                    "Community",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 10),
            child: IconButton(
              icon: Icon(
                CustomIcons.hamburger,
                size: 30,
              ),
              onPressed: () {
                return Scaffold.of(context).openDrawer();
              },
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10),
          child: InkWell(
            splashColor: Colors.red,
            onTap: () {},
            child: const Icon(
              Icons.account_circle,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
