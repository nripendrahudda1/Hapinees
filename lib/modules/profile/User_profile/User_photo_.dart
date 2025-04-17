import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserphotoDetailsScreen extends StatelessWidget {
  final String tag;
  final String? userProfilePictureUrl;

  const UserphotoDetailsScreen({
    super.key,
    required this.tag,
    this.userProfilePictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Center(
            child: Hero(
              tag: tag,
              child: userProfilePictureUrl != null
                  ? CachedNetworkImage(
                      imageUrl: userProfilePictureUrl!,
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
