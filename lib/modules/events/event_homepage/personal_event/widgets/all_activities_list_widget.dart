import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/e-card/controllers/personal_event_ecard_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/widgets/personal_event_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api_urls.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../../../utility/API/fetch_api.dart';
import '../../../../memories/video_player.dart';

class AllActivityListWidget extends StatefulWidget {
  const AllActivityListWidget(
      {super.key,
      required this.stopPlayer,
      required this.favClick,
      required this.likesCount,
      required this.isFav,
      this.activityCount});
  final Function() stopPlayer;
  final Function() favClick;
  final bool isFav;
  final int likesCount;
  final int? activityCount;

  @override
  _AllActivityListWidgetState createState() => _AllActivityListWidgetState();
}

class _AllActivityListWidgetState extends State<AllActivityListWidget> {
  double opacity = 1.0;
  Future<bool> generateVideo({required String weddingHeaderId}) async {
    print('Wedding header id $weddingHeaderId');
    String url = ApiUrl.generatePersonalEventVideo;
    await ApiService.fetchApi(
      context: context,
      url: url,
      isLoader: true,
      params: {"personalEventHeaderId": weddingHeaderId, "createdOn": nowutc(isLocal: true)},
      onSuccess: (res) {
        if (res['responseStatus'].toString().toLowerCase() == 'true') {
          EasyLoading.showError('Generating Video...', duration: const Duration(seconds: 6));
        } else {
          EasyLoading.showError(res['validationMessage'].toString(),
              duration: const Duration(seconds: 6));
        }
      },
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (widget.activityCount ?? 0) > 0 ? 160.h : 80.h,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels > 0) {
              setState(() {
                opacity = 0.0;
              });
            } else {
              setState(() {
                opacity = 1.0;
              });
            }
          }
          return false;
        },
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: ref
                              .watch(personalEventHomeController)
                              .homePersonalEventDetailsModel
                              ?.personalEventActivityList ==
                          null ||
                      ref
                              .watch(personalEventHomeController)
                              .homePersonalEventDetailsModel
                              ?.personalEventActivityList
                              ?.length ==
                          0
                  ? []
                  : [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        //physics: ClampingScrollPhysics(),
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Consumer(
                              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                final personalEventCtr = ref.watch(personalEventHomeController);
                                return personalEventCtr.homePersonalEventDetailsModel == null ||
                                        personalEventCtr.homePersonalEventDetailsModel
                                                ?.personalEventActivityList ==
                                            null ||
                                        // ignore: prefer_is_empty
                                        personalEventCtr.homePersonalEventDetailsModel
                                                ?.personalEventActivityList?.length ==
                                            0
                                    ? const SizedBox()
                                    : ListView.builder(
                                        itemCount: personalEventCtr.homePersonalEventDetailsModel
                                            ?.personalEventActivityList?.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          PersonalEventActivityList model = personalEventCtr
                                              .homePersonalEventDetailsModel!
                                              .personalEventActivityList![index];

                                          return PersonalEventCard(
                                            activityIndex: index,
                                            stopPlayer: widget.stopPlayer,
                                            activityModel: model,
                                            favClick: widget.favClick,
                                            isFav: widget.isFav,
                                            likesCount: widget.likesCount,
                                            homePersonalEventDetailsModel:
                                                personalEventCtr.homePersonalEventDetailsModel!,
                                          );
                                        },
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                      /*SizedBox(
                  width: 15.w,
                ),
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    final personalEventCtr = ref.watch(personalEventHomeController);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(
                              milliseconds: 500), // Adjust duration as needed
                          child: personalEventCtr.homePersonalEventDetailsModel?.videoStatus == 2 ?
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoApp(
                                          videoUrl:
                                          personalEventCtr.homePersonalEventDetailsModel?.videoUrl ?? '')));
                            },
                            child: Image.asset(
                              TImageName.playPngIcon,
                              color: TAppColors.orange,
                              width: 40.w,
                              height: 40.h,
                            ),
                          ):
                          personalEventCtr.homePersonalEventDetailsModel?.videoStatus == 3 ?
                          InkWell(
                            onTap: () {
                              generateVideo(weddingHeaderId: personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId.toString() ?? '');
                            },
                            child: Image.asset(
                              TImageName.playPngIcon,
                              width: 40.w,
                              height: 40.h,
                            ),
                          ):
                          SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: Stack(
                              children: [
                                const CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Image.asset(
                                    TImageName.playPngIcon,
                                    width: 20.w,
                                    height: 20.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(
                              milliseconds: 500), // Adjust duration as needed
                          child: IconButton(
                            //padding: EdgeInsets.only(left: 5.w),
                            alignment: Alignment.center,
                            enableFeedback: true,
                            icon: Image.asset(
                              ref.read(personalEventHomeController).userRoleEnum.type == UserRoleEnum.PublicUser.type ?
                              TImageName.sharePngIcon : TImageName.shareBoxedPngIcon,
                              width: 20.w,
                              height: 20.h,
                            ),
                            onPressed: () async{
                              List<int> activityId = [];
                              for(int i = 0;i < (ref.read(personalEventHomeController).homePersonalEventDetailsModel?.personalEventActivityList?.length ?? 0); i++) {
                                activityId.add(ref.read(personalEventHomeController).homePersonalEventDetailsModel?.personalEventActivityList?[i].personalEventActivityId ?? 0);
                              }
                              ref.read(personalEventECardCtr).fetchAndSetPersonalEventPhotos(
                                  ref: ref,
                                  context: context,
                                  activityId: activityId
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),*/
                    ],
            );
          },
        ),
      ),
    );
  }
}
