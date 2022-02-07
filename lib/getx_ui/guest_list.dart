import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestList2 extends StatelessWidget {
  final List<UserDetailsModel>? guests;
  GuestList2({Key? key, this.guests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Guests of this particular party fetched below"),
        Text(guests![0].age.toString()),
        Flexible(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
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
                    "Go Back",
                    style: TextStyle(color: Colors.black),
                  )),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
