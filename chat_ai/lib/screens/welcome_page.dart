import 'package:chat_ai/screens/chat_screen.dart';
import 'package:chat_ai/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key, required this.userName, required this.imageUrl});
  final String userName;
  final String imageUrl;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/welcome_bg.jpg'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
              ),
              Positioned.fill(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      CustomButton(
                          onTap: () {
                            Get.offAll(ChatScreen());
                          },
                          image: SizedBox(),
                          text: 'Okay',
                          isBusy: false)
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
