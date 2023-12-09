import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageBuilder extends StatelessWidget {
  const ImageBuilder({
    super.key, required this.imageUrl,
    
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl:imageUrl,
        height: 80,
        width: 80,
        imageBuilder: (context, imageProvider) => Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
        placeholder: (context, url) => Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 208, 202, 219),
              shape: BoxShape.circle,
            )),
        errorWidget: (context, url, error) => Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 208, 202, 219),
              shape: BoxShape.circle,
            ),
            ));
  }
}
