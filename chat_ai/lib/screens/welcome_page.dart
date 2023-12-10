import 'package:chat_ai/controllers/user_controller.dart';
import 'package:chat_ai/screens/chat_history.dart';
import 'package:chat_ai/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({
    super.key,
  });

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 188, 129),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/cartoon_chat.jpeg'),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Hello ${UserController.user!.displayName}!',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage:
                  NetworkImage(UserController.user!.photoURL ?? ''),
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                'My name is ChatAI. Your AI chat buddy.Feel free to ask me any question and I will do my best to assit you.', 
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,),
          ),
        ],
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CustomButton(
            onTap: (() => Get.offAll(const ChatHistory())),
            buttonColor: Colors.white,
            textColor:  Colors.deepOrange,
            image: const Icon(
              Icons.chat,
              color: Colors.orange,
            ),
            text: 'Let\'s ChatAI!',
            isBusy: false),
      ),
    );
  }
}
