import 'package:flutter/material.dart';

class ShowLocationBanner extends StatelessWidget {
  const ShowLocationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showMaterialBanner(
          const MaterialBanner(
            content: Text('Always Location permission denied. Please enable it'),
            actions: <Widget>[
              // TextButton(
              //   onPressed: null,
              //   child: Text('DISMISS'),
              // ),
            ],
          ),
        );
      },
      child: const Text('Show MaterialBanner'),
    );
  }
}