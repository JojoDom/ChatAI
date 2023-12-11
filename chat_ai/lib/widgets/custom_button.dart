import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.image,
      required this.text,
      this.buttonColor,
      required this.isBusy,
      this.borderColor,
      this.border,
      this.textColor});

  final VoidCallback onTap;
  final Widget image;
  final String text;
  final Color? textColor;
  final Color? buttonColor;
  final BoxBorder? border;
  final Color? borderColor;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return  isBusy? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ],
          ):
    InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
            color: buttonColor ?? Colors.white,
            border: Border.all(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              IconButton(onPressed: () {}, icon: image),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
