import 'package:chat_ai/screens/chat_screen.dart';
import 'package:chat_ai/widgets/custom_button.dart';
import 'package:chat_ai/widgets/image_builder.dart';
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
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/welcome_bg.jpg'),
                      fit: BoxFit.cover)),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.blueGrey.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Text(
                        'Hello👋',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 50,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4),
                              child: Text(
                                widget.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                    Text(
                      'Welcome to ChatAI!',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    const Text(
                      'Unleash the power of AI in your chats! Ready for smart and fun conversations? Let\'s ChatAI!',
                      textAlign: TextAlign.center,
                    ),
                    CustomButton(
                        onTap: () {
                          Get.offAll(const ChatScreen());
                        },
                        image: const Icon(Icons.chat),
                        text: 'Start chatting',
                        textColor: Colors.white,
                        buttonColor: Colors.blueGrey,
                        isBusy: false)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
