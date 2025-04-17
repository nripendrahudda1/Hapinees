import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/update_wedding_event_post_model.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/wedding_event/update_wedding_couple_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/common_update_event_dates_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/wedding_event/update_wedding_rituals_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/common_update_event_title_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/common_update_event_visibility_controller.dart';

import '../../../../../common/common_functions/datetime_functions.dart';
import '../../../../../common/common_functions/topPadding.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../controllers/common_update_event_whocanpost_visibility_controller.dart';
import '../../controllers/wedding_event/update_wedding_event_controller.dart';
import '../../controllers/wedding_event/update_wedding_style_controller.dart';
import '../../../../../common/widgets/common_delete_event_dialouge.dart';
import '../../widgets/more_info_screen_widget/update_info_message_from_the_host_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_backeground_image_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_upload_audio_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_upload_invitation_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_venue_widget.dart';

class UpdateWeddingEventMoreInfoScreen extends ConsumerStatefulWidget {
  final HomeWeddingDetailsModel homeModel;
  const UpdateWeddingEventMoreInfoScreen({super.key, required this.homeModel});

  @override
  ConsumerState<UpdateWeddingEventMoreInfoScreen> createState() =>
      _UpdateWeddingEventMoreInfoScreenState();
}

class _UpdateWeddingEventMoreInfoScreenState
    extends ConsumerState<UpdateWeddingEventMoreInfoScreen> {
  String? bgImage;
  String? bgExtension;
  String? invitationImage;
  String? invitationExtension;
  String? audio;
  String? audioExtension;
  String? aboutEvent;
  String? venueName;
  double? lat;
  double? lng;
  String? countryCode;

  Future<void> delete(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CommonDeleteEventDialouge(
          onTap: () async {
            await ref.read(updateWeddingRitualsCtr).deleteWedding(
                weddingHeaderId: widget.homeModel.weddingHeaderId.toString(), ref: ref);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          title: 'Wedding',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Latitude**: ${widget.homeModel.venueAddress ?? '0.0'}');
    print('Latitude**: ${widget.homeModel.venueLat ?? '0.0'}');
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: TAppColors.white,
        body: Column(
          children: [
            topPadding(topPadding: 0.h, offset: 30.h),
            CustomAppBar(
              onTap: () {
                Navigator.pop(context);
              },
              title: 'Update Event',
              hasSubTitle: true,
              subtitle: ref.watch(updateEventTitleCtr).title,
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.h),
                  child: Column(
                    children: [
                      UpdateInfoBackgroundImageWidget(
                        imgUrl: widget.homeModel.backgroundImageUrl,
                        bgExt: (val) {
                          // setState(() {
                          bgExtension = val;
                          // });
                        },
                        bgImage: (val) {
                          // setState(() {
                          bgImage = val;
                          // });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateInfoMessageFromTheHostWidget(
                        about: widget.homeModel.aboutTheWedding ?? "",
                        aboutText: (val) {
                          // setState(() {
                          aboutEvent = val;
                          // });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateInfoVenueWidget(
                        venue: widget.homeModel.venueAddress ?? '',
                        location: widget.homeModel.venueLat.toString() == 'null'
                            ? const LatLng(0.0, 0.0)
                            : LatLng(double.parse(widget.homeModel.venueLat ?? '0.0'),
                                double.parse(widget.homeModel.venueLong ?? '0.0')),
                        venueText: (val) {
                          venueName = val;
                          print('PlaceName: $venueName');
                        },
                        venueLatLng: (val) {
                          // setState(() {
                          lat = val.latitude;
                          lng = val.longitude;
                          // });
                        },
                        countryCode: (val) {
                          // setState(() {
                          countryCode = val;
                          print('CountryCode: $countryCode');
                          // });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateInfoUploadInvitationWidget(
                        inviteFileLink: widget.homeModel.invitationUrl,
                        invitationExt: (val) {
                          // setState(() {
                          invitationExtension = val;
                          // });
                        },
                        invitationPath: (val) {
                          // setState(() {
                          invitationImage = val;
                          print(invitationImage);
                          // });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateInfoUploadAudioWidget(
                        audioFileLink: widget.homeModel.backgroundMusicUrl,
                        audioExt: (val) {
                          // setState(() {
                          audioExtension = val;
                          print('audioExt : $audioExtension');
                          // });
                        },
                        audioPath: (val) {
                          // setState(() {
                          audio = val;
                          print('audio : $val');

                          // });
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final wedStyleCtr = ref.watch(updateWeddingStylesCtr);
                          final wedRitualCtr = ref.watch(updateWeddingRitualsCtr);
                          final wedCoupleCtr = ref.watch(updateWeddingCoupleCtr);
                          final wedTitleCtr = ref.watch(updateEventTitleCtr);
                          final wedDateCtr = ref.watch(updateEventDatesCtr);
                          final wedVisibilityCtr = ref.watch(updateEventVisibilityCtr);
                          final eventVisibilityPost = ref.watch(updateWhoPostCtr);
                          List<Ritual> weddingRituals = [];
                          int index = 0;
                          for (var ritual in wedRitualCtr.selectedRitualModels) {
                            Ritual model = Ritual(
                                ritualName: ritual.ritualName,
                                weddingRitualMasterId: ritual.weddingRitualMasterId);

                            index = index + 1;
                            weddingRituals.add(model);
                          }

                          for (var ritual in wedRitualCtr.writeByHandRitualss) {
                            Ritual model = Ritual(
                              ritualName: ritual,
                            );

                            index = index + 1;
                            weddingRituals.add(model);
                          }

                          return TButton(
                            onPressed: () async {
                              UpdateWeddingEventPostModel model = UpdateWeddingEventPostModel(
                                countryCode: countryCode ?? '',
                                weddingStyleMasterId: wedStyleCtr.weddingStyleMasterId != null &&
                                        wedStyleCtr.weddingStyleMasterId != ''
                                    ? int.parse(wedStyleCtr.weddingStyleMasterId!)
                                    : null,
                                weddingHeaderId: widget.homeModel.weddingHeaderId,
                                modifiedOn: DateTime.now(),
                                isActive: true,
                                visibility: wedVisibilityCtr.public
                                    ? 1
                                    : wedVisibilityCtr.private
                                        ? 2
                                        : 3,
                                venueLat:
                                    lat != null ? lat.toString() : widget.homeModel.venueLat ?? '',
                                venueLong:
                                    lng != null ? lng.toString() : widget.homeModel.venueLong ?? '',
                                venueAddress: venueName ?? widget.homeModel.venueAddress,
                                weddigStyleName: wedStyleCtr.selectedStyles,
                                endDateTime: wedDateCtr.date2 != "End Date"
                                    ? convertStringToDateTime(wedDateCtr.date2)
                                    : convertStringToDateTime(wedDateCtr.date1),
                                startDateTime: convertStringToDateTime(wedDateCtr.date1),
                                partner2: wedCoupleCtr.couple2Name,
                                partner1: wedCoupleCtr.couple1Name,
                                invitationData: invitationImage ?? '',
                                invitationExtention: invitationExtension ?? '',
                                multipleDayEvent: wedDateCtr.isMultipleDay,
                                rituals: wedRitualCtr.selectedRitualModels.isEmpty
                                    ? null
                                    : wedRitualCtr.selectedRitualModels,
                                title: wedTitleCtr.title,
                                aboutTheWedding: aboutEvent ?? '',
                                backgroundImageData: bgImage ?? '',
                                backgroundImageExtention: bgExtension ?? '',
                                backgroundMusicData: audio ?? '',
                                backgroundMusicExtention: audioExtension ?? '',
                                selfRegistration: wedVisibilityCtr.selfRegistration,
                                contributor: eventVisibilityPost.public
                                    ? 1
                                    : eventVisibilityPost.onlyHost
                                        ? 2
                                        : 3,
                              );
                              log(updateWeddingEventPostModelToJson(model));
                              for (var element in wedRitualCtr.selectedRitualModels) {
                                print(
                                    '{{{{{{{{{{{{{{{{{{********************************}}}}}}}}}}}}}}}}}}');
                                print(
                                    'Rituals Length : ${wedRitualCtr.selectedRitualModels.length}');
                                print('Ritual Name : ${element.ritualName}');
                                print('Ritual Master : ${element.weddingRitualMasterId}');
                                print('Ritual ID : ${element.weddingRitualId}');
                                print('********************************');
                              }

                              await ref.read(updateWeddingEventController).updateEvent(
                                  updateEventPostModel: model, ref: ref, context: context);
                              wedRitualCtr.clearRitualss();
                            },
                            title: TButtonLabelStrings.updateButton,
                            buttonBackground: TAppColors.themeColor,
                            fontSize: MyFonts.size14,
                          );
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            delete(context);
                          },
                          child: Text(
                            TButtonLabelStrings.deleteButton,
                            style: getRobotoBoldStyle(
                                fontSize: MyFonts.size14, color: TAppColors.buttonRed),
                          )),
                      SizedBox(
                        height: 55.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
