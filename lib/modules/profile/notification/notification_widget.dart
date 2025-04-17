import 'package:Happinest/core/api_urls.dart';
import 'package:Happinest/core/enums/user_role_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/modules/setting%20screen/settings_model.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import '../../../common/common_imports/common_imports.dart';
import '../../events/event_homepage/wedding_event/views/wedding_event_homepage.dart';
import '../../setting screen/html_view_screen.dart';
import '../followers_sreen.dart';
import 'notification_model.dart';

class NotificationWidget extends StatelessWidget {
  final Notifications data;
  final Function(Notifications data) onClick;
  const NotificationWidget(
      {super.key, required this.data, required this.onClick});

  Future readNotifications(String notificationID, BuildContext context) async {
    var url =
        '${ApiUrl.authentication}$notificationID/true/${ApiUrl.reedUnReedNotificationGet}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: false,
      onSuccess: (res) {
        onClick(data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            backgroundImage:
                CachedNetworkImageProvider(data.imageUrl.toString()),
          ),
          title: Html(
            data: data.notificationText.toString(),
          ),
          trailing: data.notificationTypeId == 1 ||
                  data.notificationTypeId == 9 ||
                  data.notificationTypeId == 10
              ? InkWell(
                  onTap: () async {
                    readNotifications(data.notificationId.toString(), context);

                    if (data.actionType
                        .toString()
                        .contains('TermsAndCondition')) {
                      var url =
                          '${ApiUrl.authentication}${ApiUrl.getCompanySetting}';
                      await ApiService.fetchApi(
                        context: context,
                        url: url,
                        get: true,
                        isLoader: true,
                        onSuccess: (res) {
                          var data = CompanySettings.fromJson(res);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HtmlViewScreen(
                                    data: data.termsAndCondition.toString(),
                                    appbarTitle: 'Terms & Conditions'),
                              ));
                        },
                      );
                    } else if (data.actionType
                        .toString()
                        .contains('PrivacyPolicy')) {
                      var url =
                          '${ApiUrl.authentication}${ApiUrl.getCompanySetting}';
                      await ApiService.fetchApi(
                        context: context,
                        url: url,
                        get: true,
                        isLoader: true,
                        onSuccess: (res) {
                          var data = CompanySettings.fromJson(res);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HtmlViewScreen(
                                    data: data.privacyPolicy.toString(),
                                    appbarTitle: 'Privacy Policy'),
                              ));
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 35,
                    width: 70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                          child: TText('Read',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    readNotifications(data.notificationId.toString(), context);

                    if (data.actionType
                        .toString()
                        .toLowerCase()
                        .contains('memory')) {
                      // data.additionalParams.toString().contains('=')
                      //     ? Navigator.pushNamed(
                      //         context, Routes.memoriesRoute, arguments: [
                      //         data.additionalParams?.split('=')[1].toString(),
                      //         null
                      //       ])
                      //     : null;
                    } else if (data.actionType
                        .toString()
                        .toLowerCase()
                        .contains('follower')) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FollowersScreen(
                                 userFollowType: FollowType.follower,
                                  data: myProfileData!,
                                  userID: myProfileData!.userId.toString())));
                    } else if (data.actionType
                        .toString()
                        .toLowerCase()
                        .contains("dashboard")) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WeddingEventHomePage()));
                    }
                  },
                  child: Container(
                    height: 35,
                    width: 70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                          child: TText('View',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                ),
        ));
  }
}
