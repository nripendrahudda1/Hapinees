import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/personal_event_invite_by_email.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/personal_event_invite_by_text_tab.dart';

import '../../../../../common/common_functions/topPadding.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';

class PersonalEventInviteGuestByEmailAndContactScreen extends StatefulWidget {
  const PersonalEventInviteGuestByEmailAndContactScreen({super.key, required this.title});
  final String title;

  @override
  State<PersonalEventInviteGuestByEmailAndContactScreen> createState() =>
      _PersonalEventInviteGuestByEmailAndContactScreenState();
}

class _PersonalEventInviteGuestByEmailAndContactScreenState
    extends State<PersonalEventInviteGuestByEmailAndContactScreen>
    with SingleTickerProviderStateMixin {
  // List<String> tabNames = ['Invite by Email', 'Invite by Text']; // User when Invite  by Text comes
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
        return const PersonalEventInviteByEmailTab();
      case 1:
        return const PersonalEventInviteByTextTab();
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
