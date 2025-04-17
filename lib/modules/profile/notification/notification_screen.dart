import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/appbar.dart';
import 'package:Happinest/modules/profile/notification/notification_model.dart';
import 'package:Happinest/modules/profile/notification/notification_widget.dart';
import 'package:Happinest/utility/API/fetch_api.dart';

import '../../../common/widgets/iconButton.dart';
import '../../../core/api_urls.dart';

class NotificationScreen extends StatefulWidget {
  final List<dynamic>? notifications;
  const NotificationScreen({super.key, this.notifications});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int index = 0;
  bool unReadOnly = true;
  NotificationModel? notificationData;
  List<Notifications> notificationList = [];
  List<Notifications> actualList = [];
  List<Notifications> pendingRequests = [];
  List<Notifications> todaysRequests = [];

  String userID = '';
  String formattedDateTime =
      DateFormat("yyyy-MM-ddTHH:mm:ss.SS").format(DateTime.now());

  @override
  void initState() {
    getNotifications(context);
    updateData();
    super.initState();
  }

  updateData() {
    if (widget.notifications != null) {
      notificationList = [];
      pendingRequests = [];
      todaysRequests = [];
      actualList = [];
      setState(() {
        for (var element in (widget.notifications!)) {
          notificationList.add(Notifications.fromJson(element));
        }
        for (var element in notificationList) {
          element.notificationTypeId == 2 || element.notificationTypeId == 3
              ? pendingRequests.add(element)
              : DateTime.parse(element.createdDate.toString()).day ==
                      DateTime.now().day
                  ? todaysRequests.add(element)
                  : actualList.add(element);
        }
      });
    } else {
      getNotifications(context);
    }
  }

  getNotifications(BuildContext context) async {
    userID = PreferenceUtils.getString(PreferenceKey.userId);
    var url =
        '${ApiUrl.authentication}$userID/$unReadOnly/${ApiUrl.getNotifications}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: true,
      onSuccess: (value) {
        notificationList = [];
        pendingRequests = [];
        todaysRequests = [];
        actualList = [];
        setState(() {
          for (var element in (value['notifications'] ?? [])) {
            notificationList.add(Notifications.fromJson(element));
          }
          for (var element in notificationList) {
            element.notificationTypeId == 2 || element.notificationTypeId == 3
                ? pendingRequests.add(element)
                : DateTime.parse(element.createdDate.toString()).day ==
                        DateTime.now().day
                    ? todaysRequests.add(element)
                    : actualList.add(element);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
        appBar: CustomAppBar(title: "Notifications",hasSuffix: false,prefixWidget: iconButton(
          bgColor: TAppColors.text4Color,
          iconPath: TImageName.back,
          radius: 24.h,
          onPressed: () {
            Navigator.pop(context);
          },
        ),),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
          child: notificationList.isNotEmpty
              ? ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: actualList.isNotEmpty
                          ? ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return NotificationWidget(
                                    onClick: (data) {
                                      log('deleting');
                                      widget.notifications?.remove(data);
                                      actualList.removeAt(index);
                                      setState(() {});
                                    },
                                    data: actualList[index]);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 10);
                              },
                              itemCount: actualList.length)
                          : const SizedBox(),
                    ),
                    pendingRequests.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: TText('Pending Request',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        : const SizedBox(),
                    ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return NotificationWidget(
                              onClick: (data) {
                                widget.notifications?.remove(data);
                                pendingRequests.removeAt(index);
                                setState(() {});
                              },
                              data: pendingRequests[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: pendingRequests.length),
                    todaysRequests.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: TText('Today',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        : const SizedBox(),
                    ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return NotificationWidget(
                              onClick: (data) {
                                widget.notifications?.remove(data);
                                todaysRequests.removeAt(index);
                                setState(() {});
                              },
                              data: todaysRequests[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: todaysRequests.length),
                  ],
                )
              : const Center(child: Text('No Notifications Found')),
        ));
  }
}
