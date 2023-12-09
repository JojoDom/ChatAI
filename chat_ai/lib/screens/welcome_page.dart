import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key, 
  required this.userName, 
  required this.imageUrl});
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
        child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Welcome'), 
          Text(widget.userName)],
        )),
      ),
    );
  }
}
