import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../../models/create_event_models/moments/personal_event_moments/personal_event_all_moment_model.dart';

class ZoomableImage extends StatefulWidget {
  final List<PersonalEventPhoto> imageUrls;
  final int selectIndex;
  final Function(int) onImageChange; // ✅ New Callback to update parent state

  const ZoomableImage({
    Key? key,
    required this.imageUrls,
    required this.selectIndex,
    required this.onImageChange, // ✅ Receive callback
  }) : super(key: key);

  @override
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  // late int selectedImage;

  @override
  void initState() {
    super.initState();
    // selectedImage = widget.selectIndex;
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
      });
  }

  void _resetZoom() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleEnd: (details) {},
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          _resetZoom();
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < 0 && widget.selectIndex < widget.imageUrls.length - 1) {
              // ✅ Swipe Left (Next Image)
              widget.onImageChange(widget.selectIndex + 1);
            } else if (details.primaryVelocity! > 0 && widget.selectIndex > 0) {
              // ✅ Swipe Right (Previous Image)
              widget.onImageChange(widget.selectIndex - 1);
            }
          }
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: false,
          scaleEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: ClipRect(
            child: Align(
              alignment: Alignment.center,
              child: CachedRectangularNetworkImageWidget(
                fit: BoxFit.contain,
                image: widget.imageUrls[widget.selectIndex].photo, // ✅ Dynamically update image
                width: 1.sw,
                height: 1.sh,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
