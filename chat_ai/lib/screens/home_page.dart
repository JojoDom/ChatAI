import 'package:chat_ai/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/welcome.jpg'),
                      fit: BoxFit.fitHeight)),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Text('ChatAI',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w500)),
                      ),
                    ),
                    CustomButton(
                      onTap: () {},
                      image: SvgPicture.asset('assets/images/welcome.jpg'),
                      text: 'Sign in with Google',
                      borderColor: Colors.blue,
                      isBusy: false,
                    ),
                    CustomButton(
                    onTap: (){}, 
                    textColor: Colors.white,
                    buttonColor: Colors.red,
                    image: const Icon(Icons.email_outlined, color: Colors.white,), 
                    text: 'Login with mail', isBusy: false)
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

