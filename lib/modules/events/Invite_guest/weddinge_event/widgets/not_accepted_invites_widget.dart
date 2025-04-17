import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';

class NotAcceptedWidget extends StatelessWidget {
  const NotAcceptedWidget(
      {super.key, required this.coHostName, this.imageUrl, this.phNumber});
  final String coHostName;
  final String? imageUrl;
  final String? phNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedCircularNetworkImageWidget(
          image: imageUrl ?? "",
          size: 36,
          name: coHostName,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coHostName,
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
        // GestureDetector(
        //   onTap: () {},
        //   child: TCard(
        //       border: true,
        //       borderColor: TAppColors.selectionColor,
        //       color: Colors.transparent,
        //       child: Padding(
        //           padding:
        //               const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //           child: Text(TLabelStrings.invite,
        //               style: getRobotoMediumStyle(
        //                 fontSize: MyFonts.size12,
        //                 color: TAppColors.selectionColor,
        //               )))),
        // ),
      ],
    );
  }
}
