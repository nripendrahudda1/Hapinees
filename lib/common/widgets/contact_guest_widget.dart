import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';

class ContactGuestWidget extends StatelessWidget {
  const ContactGuestWidget(
      {super.key, required this.name, this.imageUrl, this.phNumber, required this.trailing});
  final String name;
  final String? imageUrl;
  final String? phNumber;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedCircularNetworkImageWidget(
          image: imageUrl ?? "",
          size: 36,
          name: name,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: getRobotoSemiBoldStyle(
                  fontSize: MyFonts.size14, color: TAppColors.black),
            ),
            SizedBox(
              height: 5.h,
            ),
            if (phNumber != null)
              Text(
                phNumber!,
                style: getRobotoMediumStyle(
                    fontSize: MyFonts.size10, color: TAppColors.black),
              ),
          ],
        ),
        const Spacer(),
        trailing,
      ],
    );
  }
}
