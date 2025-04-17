import 'event_t_card.dart';
import '../common_imports/common_imports.dart';
import 'comment_common_dropdown.dart';

List<String> commonCommentFilterList = [
  'Most Recent',
  'Popular',
];

class CommonCommentsHeaderView extends StatelessWidget {
  CommonCommentsHeaderView({super.key,required this.selectedFilter,required this.onChanged,required this.commentCount});
  String? selectedFilter;
  String? commentCount;
  dynamic Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "Comments",
              style: getBoldStyle(
                  fontSize: MyFonts.size14,
                  color: TAppColors.white),
            ),
            SizedBox(width: 6.w),
            EventTCard(
                color: Colors.white,
                radius: 12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2, horizontal: 6),
                  child: TText(
                      commentCount.toString(),
                      color: TAppColors.text1Color,
                      fontSize: MyFonts.size12,
                      fontWeight: FontWeight.w800),
                )),
          ],
        ),
        CommonDropDown(
          width: 130.w,
          height: 24.h,
          valueItems: commonCommentFilterList,
          onChanged: onChanged,
          value: selectedFilter,
          hintText: 'Sort',
          label: 'Sort',
        )
      ],
    );
  }
}
