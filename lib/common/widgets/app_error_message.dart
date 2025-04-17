import 'package:Happinest/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;

  const CustomErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: TAppColors.errorMessageback,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16.0, color: TAppColors.errorMessage),
            ),
          ),
        ),
      ),
    );
  }
}
