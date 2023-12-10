import 'package:chat_ai/controllers/auth_controller.dart';
import 'package:chat_ai/controllers/user_controller.dart';
import 'package:chat_ai/screens/welcome_page.dart';
import 'package:chat_ai/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  var authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

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
                    Animate(
                      effects: const [
                        SlideEffect(
                            duration: Duration(
                              milliseconds: 900,
                            ),
                            curve: Curves.linear)
                      ],
                      child: Padding(
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
                    ),
                    CustomButton(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final user = await UserController.loginWithGoogle();
                          if (user != null) {
                            setState(() {
                              isLoading = false;
                            });                           
                            await authController.userHandOff(
                                userName: user.displayName ?? '',
                                email: user.email ?? '',
                                phoneNumber: user.phoneNumber??'',
                                imageURL: user.photoURL ?? '');
                          } else {
                            Get.defaultDialog(
                                title: 'Ooops',
                                middleText:
                                    'Failed to fetch details for this google account. Try again or use a different method to login');
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } on FirebaseAuthException catch (error) {
                          print(error.message);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  error.message ?? 'Something went wrong.')));
                        } catch (e) {
                          Logger().i(e);
                          Logger().f(e);
                        }
                      },
                      image: SizedBox(
                          height: 30,
                          child: Image.asset('assets/images/google.png')),
                      text: 'Sign in with Google',
                      borderColor: Colors.blue,
                      isBusy: isLoading,
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                        onTap: () {},
                        textColor: Colors.white,
                        buttonColor: const Color.fromARGB(255, 209, 138, 132),
                        image: const Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                        ),
                        text: 'Login with mail',
                        isBusy: false),
                    const SizedBox(height: 10),
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
