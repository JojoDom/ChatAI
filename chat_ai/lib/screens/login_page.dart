import 'package:chat_ai/controllers/auth_controller.dart';
import 'package:chat_ai/controllers/user_controller.dart';
import 'package:chat_ai/widgets/custom_button.dart';
import 'package:cherry_toast/cherry_toast.dart';
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
  late AuthController authController;

  @override
  void initState() {
    authController = Get.put(AuthController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/welcome.jpg'),
                    fit: BoxFit.cover)),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomButton(
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
                                phoneNumber: user.phoneNumber ?? '',
                                imageURL: user.photoURL ?? '');
                          } else {
                            CherryToast.error(
                                title:
                                    const Text('Failed to authenticate user'));
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } on FirebaseAuthException catch (error) {
                          setState(() {
                            isLoading = false;
                          });
                          // ignore: use_build_context_synchronously
                          CherryToast.error(
                              title: const Text('Failed to authenticate user'));
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          Logger().i(e);
                          Logger().f(e);
                        }
                      },
                      image: SizedBox(
                          height: 30,
                          child: Image.asset('assets/images/google.png')),
                      text: 'Sign in with Google',
                      isBusy: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
