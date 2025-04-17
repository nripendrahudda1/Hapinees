import 'package:cached_network_image/cached_network_image.dart';

import '../common_imports/common_imports.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// DefaultCacheManager cacheManager = DefaultCacheManager();

class CachedRectangularNetworkImageWidget extends StatelessWidget {
  const CachedRectangularNetworkImageWidget({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.errorWidget,
    this.fit,
    this.radius,
  });

  final String image;
  final double width;
  final double height;
  final BoxFit? fit;
  final double? radius;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: width,
      height: height,
      child: image.isNotEmpty && image != 'null'
          ? CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(radius ?? 5),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit ?? BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => TCard(
                radius: radius ?? 5,
                color:
                    Colors.grey[300], // Use a light grey color as a placeholder
              ),
              errorWidget: (context, url, error) =>
                  errorWidget ??
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [TAppColors.themeColor, TAppColors.white]),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(radius ?? 5),
                      ),
                    ),
                  ),
            )
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [TAppColors.themeColor, TAppColors.white]),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(radius ?? 5),
                ),
              ),
            ),
    );

    // SizedBox(
    //   width: width,
    //   height: height,
    //   child: CachedNetworkImage(
    //     // cacheManager: cacheManager,
    //     imageUrl: image,
    //     imageBuilder: (context, imageProvider) => Container(
    //       decoration: BoxDecoration(
    //         shape: BoxShape.rectangle,
    //         borderRadius: BorderRadius.circular(radius ?? 5.r),
    //         image:
    //             DecorationImage(image: imageProvider, fit: fit ?? BoxFit.cover),
    //       ),
    //     ),
    //     placeholder: (context, url) => const Center(child: ShimmerWidget()),
    //     errorWidget: (context, url, error) =>
    //         errorWidget ??
    //         Center(
    //             child: SizedBox(
    //                 width: 20.w, height: 20.h, child: const Icon(Icons.error))),
    //   ),
    // );
  }
}
