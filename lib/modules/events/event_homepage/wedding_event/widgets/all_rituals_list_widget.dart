import 'package:Happinest/core/api_urls.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/widgets/wedding_event_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/e-card/controllers/wedding_event_ecard_controller.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../../../../utility/API/fetch_api.dart';
import '../../../../memories/video_player.dart';

class AllRitualListWidget extends StatefulWidget {
  const AllRitualListWidget({super.key, required this.stopPlayer});
  final Function() stopPlayer;

  @override
  _AllRitualListWidgetState createState() => _AllRitualListWidgetState();
}

class _AllRitualListWidgetState extends State<AllRitualListWidget> {
  double opacity = 1.0;
  Future<bool> generateVideo({required String weddingHeaderId}) async {
    print('Wedding header id $weddingHeaderId');
    String url = ApiUrl.generateWeddingVideo;
    await ApiService.fetchApi(
      context: context,
      url: url,
      isLoader: true,
      params: {"weddingHeaderId": weddingHeaderId, "createdOn": nowutc(isLocal: true)},
      onSuccess: (res) {
        if (res['responseStatus'].toString().toLowerCase() == 'true') {
          EasyLoading.showError('Generating Video...',duration: const Duration(seconds: 6));
        } else {
          EasyLoading.showError(res['validationMessage'].toString(),duration: const Duration(seconds: 6));
        }
      },
    );
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
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
              children: [
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
                          final weddingCtr = ref.watch(weddingEventHomeController);
                          return
                            weddingCtr.homeWeddingDetails == null ||
                                weddingCtr.homeWeddingDetails?.weddingRitualList == null||
                                weddingCtr.homeWeddingDetails?.weddingRitualList?.length == 0 ?
                            const SizedBox():
                            ListView.builder(
                              itemCount: weddingCtr.homeWeddingDetails?.weddingRitualList?.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                WeddingRitualList model = weddingCtr.homeWeddingDetails!.weddingRitualList![index];

                                return WeddingEventCard(
                                  ritualIndex: index,
                                  stopPlayer: widget.stopPlayer,
                                  ritualModels: model,
                                  homeWeddingDetailsModel: weddingCtr.homeWeddingDetails!,
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
                    final weddingHomeCtr = ref.watch(weddingEventHomeController);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(
                              milliseconds: 500), // Adjust duration as needed
                          child: weddingHomeCtr.homeWeddingDetails?.videoStatus == 2 ?
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoApp(
                                          videoUrl:
                                          weddingHomeCtr.homeWeddingDetails?.videoUrl ?? '')));
                            },
                            child: Image.asset(
                              TImageName.playPngIcon,
                              color: TAppColors.orange,
                              width: 40.w,
                              height: 40.h,
                            ),
                          ):
                          weddingHomeCtr.homeWeddingDetails?.videoStatus == 3 ?
                          InkWell(
                            onTap: () {
                              generateVideo(weddingHeaderId: weddingHomeCtr.homeWeddingDetails?.weddingHeaderId.toString() ?? '');
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
                              ref.read(weddingEventHomeController).userRoleEnum.type == UserRoleEnum.PublicUser.type ?
                              TImageName.sharePngIcon : TImageName.shareBoxedPngIcon,
                              width: 20.w,
                              height: 20.h,
                            ),
                            onPressed: () async{
                              ref.read(weddingEventECardCtr).fetchAllWeddingImages(
                                  ref: ref,
                                  context: context,
                                  weddingHeaderId: ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId.toString() ?? ''
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
