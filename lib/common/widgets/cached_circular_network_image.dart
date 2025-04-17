import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:Happinest/common/widgets/loading_images_shimmer.dart';
import '../common_imports/common_imports.dart';

class CachedCircularNetworkImageWidget extends StatelessWidget {
  const CachedCircularNetworkImageWidget({
    super.key,
    required this.image,
    required this.size,
    this.isWhiteBorder,
    this.name = 'UnKnown',
    this.imageBoxType,
  });

  final String image;
  final int size;
  final String name;
  final bool? isWhiteBorder;
  final BoxFit? imageBoxType;

  @override
  Widget build(BuildContext context) {
    return image == ''
        ? Initicon(
            text: name,
            backgroundColor: TAppColors.textImageBgColor,
            borderRadius: BorderRadius.circular(100),
            style: getRobotoMediumStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
            size: size.h,
          )
        : SizedBox(
            width: size.w,
            height: size.h,
            child: CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: (isWhiteBorder ?? false)
                      ? Border.all(width: 1.5, color: TAppColors.white)
                      : null,
                  image: DecorationImage(image: imageProvider, fit: imageBoxType ?? BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Center(
                child: ShimmerWidget(
                  border: 100.r,
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Initicon(
                  text: name,
                  backgroundColor: TAppColors.textImageBgColor,
                  borderRadius: BorderRadius.circular(100),
                  style: getRobotoMediumStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
                  size: size.h,
                ),
              ),
            ),
          );
  }
}
