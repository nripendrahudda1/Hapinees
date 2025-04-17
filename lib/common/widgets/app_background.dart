import 'package:flutter/material.dart';

class TBackgroundImage extends StatelessWidget {
  const TBackgroundImage({super.key, required this.imageName});

  final String imageName;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageName),
          fit: BoxFit.cover,
        ),
      ),
      child: null /* add child content here */,
    );
  }
}
