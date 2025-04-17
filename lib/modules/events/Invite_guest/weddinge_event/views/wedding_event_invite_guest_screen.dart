import 'package:Happinest/common/common_functions/topPadding.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../widgets/wedding_event_invite_by_email_tab.dart';

class WeddingEventInviteGuestScreen extends StatefulWidget {
  const WeddingEventInviteGuestScreen({super.key, required this.title});
  final String title;

  @override
  State<WeddingEventInviteGuestScreen> createState() => _WeddingEventInviteGuestScreenState();
}

class _WeddingEventInviteGuestScreenState extends State<WeddingEventInviteGuestScreen>
    with SingleTickerProviderStateMixin {
  //List<String> tabNames = ['Invite by Email', 'Invite by Text']// User for future
  List<String> tabNames = ['Invite by Email'];
  late TabController _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: tabNames.length, vsync: this);
    super.initState();
  }

  buildTabRow(context) {
    return Container(
      // height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i in tabNames)
            buildTabButton(context: context, icon: i, index: tabNames.indexOf(i), function: () {}),
        ],
      ),
    );
  }

  buildTabButton(
      {required BuildContext context,
      required String icon,
      required Function function,
      required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = tabNames.indexOf(icon);
            _tabController.index = tabNames.indexOf(icon);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Center(
              child: Column(
            children: [
              Text(
                icon,
                style: tabNames.indexOf(icon) == _tabController.index
                    ? getBoldStyle(fontSize: MyFonts.size14, color: TAppColors.black)
                    : getRegularStyle(fontSize: MyFonts.size14, color: TAppColors.text2Color),
              ),
              SizedBox(
                height: 3.h,
              ),
              Container(
                margin: EdgeInsets.only(top: 4.h),
                width: double.infinity,
                height: 2.h,
                color: tabNames.indexOf(icon) == currentIndex
                    ? TAppColors.selectionColor
                    : TAppColors.lightBorderColor,
              )
            ],
          )),
        ),
      ),
    );
  }

  handleTabPages(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const WeddingEventInviteByEmailTab();
      // case 1:
      //   return const WeddingEventInviteByTextTab();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: TAppColors.white,
        body: Column(
          children: [
            topPadding(topPadding: 0, offset: 30),
            CustomAppBar(
              onTap: () {
                Navigator.pop(context);
              },
              title: TNavigationTitleStrings.inviteGuests,
              hasSubTitle: true,
              subtitle: widget.title,
            ),
            SizedBox(
              height: 20.h,
            ),
            buildTabRow(context),
            handleTabPages(context, currentIndex),
          ],
        ),
      ),
    );
  }
}
