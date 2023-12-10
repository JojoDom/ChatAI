import 'package:auth_state_manager/auth_state_manager.dart';
import 'package:chat_ai/firebase_options.dart';
import 'package:chat_ai/screens/chat_history.dart';
import 'package:chat_ai/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'themes/themes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: "assets/.env");
  await AuthStateManager.initializeAuthState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(
      child: GetMaterialApp(
        title: 'ChatAI',
        theme: Themes.lightTheme,
        darkTheme: Themes.darkTheme,
        home: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthStateListener(
        authenticated: ChatHistory(),
         unAuthenticated: LoginPage());
  }
}
