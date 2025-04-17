import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/widgets/appbar.dart';
import 'package:Happinest/modules/events/e-card/controllers/wedding_event_ecard_controller.dart';
import 'package:Happinest/modules/events/e-card/views/wedding_event/wedding_ecard_screen.dart';
import 'package:Happinest/theme/font_manager.dart';
import 'package:Happinest/utility/constants/constants.dart';

import '../../../../../common/widgets/app_text.dart';
import '../../../../../theme/app_colors.dart';


class WeddingEcardImagePCropper extends ConsumerStatefulWidget {
  final String selectedImage;

  const WeddingEcardImagePCropper(
      {super.key,
        required this.selectedImage,
      });

  @override
  ConsumerState<WeddingEcardImagePCropper> createState() => _WeddingEcardImagePCropperState();
}

class _WeddingEcardImagePCropperState extends ConsumerState<WeddingEcardImagePCropper> {
  final controller = CropController(
    aspectRatio: 9 / 16,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const CustomAppBar(title: 'Crop Image'),
    body: Center(
      child: CropImage(
        controller: controller,
        image: Image.network(widget.selectedImage),
        paddingSize: 25.0,
        alwaysMove: true,
        minimumImageSize: 200,
      ),
    ),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(8.0)
          .copyWith(bottom: bottomSfarea > 4 ? bottomSfarea : 8),
      child: _buildButtons(),
    ),
  );

  Widget _buildButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          controller.rotation = CropRotation.up;
        },
      ),
      IconButton(
        icon: const Icon(Icons.rotate_90_degrees_ccw_outlined),
        onPressed: _rotateLeft,
      ),
      IconButton(
        icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
        onPressed: _rotateRight,
      ),
      TextButton(
        onPressed: _finished,
        child: TText('Done',
            color: TAppColors.themeColor, fontSize: MyFonts.size16),
      ),
    ],
  );

  Future<void> _rotateLeft() async => controller.rotateLeft();

  Future<void> _rotateRight() async => controller.rotateRight();

  Future<void> _finished() async {
    final image = await controller.croppedImage();
    ref.read(weddingEventECardCtr).setSelectedImage(image);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WeddingECardScreen(
          ),
        ));
  }
}
