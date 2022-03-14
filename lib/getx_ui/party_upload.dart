import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PartyUpload extends StatefulWidget {
  PartyUpload({Key? key}) : super(key: key);

  @override
  State<PartyUpload> createState() => _PartyUploadState();
}

class _PartyUploadState extends State<PartyUpload> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController partyTitleController = TextEditingController();
  final TextEditingController entryFeeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descriptionController  = TextEditingController();
  final TextEditingController promotionController  = TextEditingController();
  final TextEditingController guestLimitController = TextEditingController();

  late FocusNode partyTitleNode ;
  late FocusNode entryFeeNode ;
  late FocusNode locationNode ;
  late FocusNode timeNode ;
  late FocusNode descriptionNode ;
  late FocusNode promotionNode ;
  late FocusNode guestLimitNode;

  String partyName = '';
  String entryFee = '';
  String location = '';
  String time = '';
  String description = '';
  String promotionBrand = '';
  String date = "";
  String guestLimit = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    partyTitleNode = FocusNode();
    entryFeeNode = FocusNode();
    locationNode = FocusNode();
    timeNode = FocusNode();
    descriptionNode = FocusNode();
    promotionNode = FocusNode();
    guestLimitNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    partyTitleNode.dispose();
    entryFeeNode.dispose();
    locationNode.dispose();
    timeNode.dispose();
    descriptionNode.dispose();
  }



  File? pickedImage;
  bool pickedImageBool = false;
  List<File> imageList = [];
  int photoIndex = 0;
  final urlList = [];
  final redundancyList =[];
  void _pickImageFromGallery() async{
    final imagePicker = ImagePicker();
    final selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(selectedImage!.path);

    setState(() {
      pickedImageBool = true;
      pickedImage = pickedImageFile;
      imageList.add(pickedImageFile);
      photoIndex = imageList.length-1;
    });
  }

  void _uploadToFirebase() async{
    int i=1;
    for(int j=0;j<imageList.length;j++){
      final ref = FirebaseStorage.instance.ref().child("parties").child(partyName).child(partyName+i.toString()+'.jpg');
      await ref.putFile(imageList[j]).whenComplete(()async {
        await ref.getDownloadURL().then((value) {
          // redundancyList.add(value);
          // if(!redundancyList.contains(value) || i==1) {
          //   urlList.add(value);
          // }
          urlList.add(value);
        });
      });
      i+=1;
    }

    print(urlList);
    FirebaseFirestore.instance.collection('PartyDetails').doc().set({
      'partyName':partyName,
      'partyId':"#mvpis",
      "partyHostId": 'Blank',
      'hostId':"#mvpis",
      'entryFee':int.parse(entryFee),
      'description':description,
      'location':location,
      'time':time,
      'date':date,
      'guests':[],
      'images':urlList
    });

  }


  Future _pickDateTime() async{
    final datePicked = await _pickDate();
    if(datePicked!=null){
      setState(() {
        // date = "${datePicked.day}/${datePicked.month}/${datePicked.year}";
        date = DateFormat('EEE, MMM d, ''yyy ').format(datePicked).toString();
      });
    }

    final timePicked = await _pickTime();
    if(timePicked!=null){
      setState(() {
        time = "${timePicked.hour}:${timePicked.minute}${timePicked.period.name}";
      });
    }
    print("$date \n Time: $time");
    timeController.text = " $date  @$time";
  }


  Future<DateTime?> _pickDate(){
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year+1)
    );
  }

  Future<TimeOfDay?> _pickTime(){
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );
  }


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      pickedImageBool?afterImagePick():Container(
                        width: w,
                        height: h * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10)
                        ),

                        child: Center(
                            child: InkWell(
                              onTap: (){
                                _pickImageFromGallery();
                              },
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.4)),
                                  child:const Center(child: Text("+", style: TextStyle(fontSize: 35, color: Colors.white),),)
                              ),
                            )),
                      ),

                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: w*0.58,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Color(0xffFFF6F6),
                                  filled: true,
                                  hintText: 'Party title',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none
                                      )
                                  )
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,

                              key: ValueKey('party Name'),
                              controller: partyTitleController,
                              focusNode: partyTitleNode,
                              onFieldSubmitted: (text){
                                partyName = text;
                                FocusScope.of(context).requestFocus(entryFeeNode);
                              },
                            ),
                          ),
                          SizedBox(
                            width: w*0.3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: const Color(0xffFFF6F6),
                                  filled: true,
                                  hintText: 'Entry Fee',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none
                                      )
                                  )
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),

                              key: const ValueKey('Entry Fee'),
                              controller: entryFeeController,
                              focusNode: entryFeeNode,
                              // onEditingComplete: ()=>Focus.of(context).requestFocus(locationNode),
                              onFieldSubmitted: (text){
                                entryFee = text;
                                FocusScope.of(context).requestFocus(locationNode);
                              },
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: w*0.58,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: const Color(0xffFFF6F6),
                                  suffixIcon: const Icon(Icons.location_on_outlined),
                                  filled: true,
                                  hintText: 'Location',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none
                                      )
                                  )
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,

                              key: ValueKey('Venue'),
                              controller: locationController,
                              focusNode: locationNode,
                              onFieldSubmitted: (text){
                                location = text;
                                FocusScope.of(context).requestFocus(guestLimitNode);
                              },
                            ),
                          ),
                          SizedBox(
                            width: w*0.3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Color(0xffFFF6F6),
                                  suffixIcon: const Icon(Icons.people_outline),
                                  filled: true,
                                  hintText: 'Limit',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none
                                      )
                                  )
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),

                              key: ValueKey('Guest Limit'),
                              controller: guestLimitController,
                              focusNode: guestLimitNode,
                              onFieldSubmitted: (text){
                                guestLimit = text;
                                FocusScope.of(context).requestFocus(timeNode);
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: w,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Color(0xffFFF6F6),
                              suffixIcon: const Icon(Icons.access_time_outlined),
                              filled: true,
                              hintText: 'Date and Time',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none
                                  )
                              )
                          ),
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                          key: const ValueKey('Date and Time'),
                          controller: timeController,
                          focusNode: timeNode,
                          onTap: (){
                            _pickDateTime();
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: w,
                        height: h*0.25,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Color(0xffFFF6F6),
                              filled: true,
                              hintText: 'Tell us about your party here',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none
                                  )
                              )
                          ),
                          maxLines: 10,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,

                          key: ValueKey('time'),
                          controller: descriptionController,
                          focusNode: descriptionNode,
                          onFieldSubmitted: (text){
                            description = text;
                            FocusScope.of(context).requestFocus(promotionNode);
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(
                            width: w*0.4,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Color(0xffFFF6F6),
                                  filled: true,
                                  hintText: 'Promotion Brand',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none
                                      )
                                  )
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,

                              key: ValueKey('time'),
                              controller: promotionController,
                              focusNode: promotionNode,
                              onFieldSubmitted: (text){
                                promotionBrand = text;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap:(){
                              print("$imageList");
                              _uploadToFirebase();

                            },
                            child: Container(
                              width: w*0.3,
                              height: h*0.05,
                              decoration: BoxDecoration(
                                  color: t.primaryColor,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)
                                  )
                              ),
                              child: Center(child:Text("Next",style: t.textTheme.headline1!.copyWith(
                                  color: Colors.black
                              ),)),
                            ),
                          ),
                          InkWell(
                            onTap:(){
                              partyTitleController.clear();
                              entryFeeController.clear();
                              locationController.clear();
                              timeController.clear();
                              descriptionController.clear();
                              promotionController.clear();
                              imageList.clear();
                              setState(() {
                                pickedImageBool = false;
                                urlList.clear();
                              });
                            },
                            child: Container(
                              width: w*0.3,
                              height: h*0.05,
                              decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)
                                  )
                              ),
                              child: Center(child:Text("Clear all",style: t.textTheme.headline1!.copyWith(
                                  color: Colors.black
                              ),)),
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
    final t = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        SizedBox(
          width: w*0.6,
          height: h*0.3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(imageList[photoIndex],fit: BoxFit.cover,),
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: (){
                _pickImageFromGallery();
              },
              child: Container(
                height: h*0.06,
                width: h*0.15,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: const Center(child:Icon(Icons.add,size: 25,color: Colors.white,)),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: w*0.3,
              height: h*0.3,
              child: ListView.builder(
                  itemCount: imageList.length,
                  itemBuilder: (context,index){
                    return InkWell(
                        onTap: (){
                          setState(() {
                            photoIndex = index;
                          });
                        },
                        child: Column(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.file(imageList[index],fit: BoxFit.cover,)),
                            const SizedBox(height: 10,)
                          ],
                        ));
                  }),
            ),
          ],
        )
      ],
    );
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
