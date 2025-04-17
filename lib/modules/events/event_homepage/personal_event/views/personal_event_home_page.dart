import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/widgets/all_activities_list_widget.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/widgets/personal_event_home_page_top_widget.dart';
import 'package:Happinest/modules/home/widget/Shimmer_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_retangular_network_image.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../common/widgets/loading_images_shimmer.dart';
import '../../../event_details_moments/views/event_details_and_moments_screen.dart';
import '../widgets/personal_event_accept_decline_card.dart';
import '../widgets/personal_event_home_page_name_and_invite_widget.dart';
import '../widgets/personal_event_home_page_side_buttons.dart';

class PersonalEventHomePage extends ConsumerStatefulWidget {
  final String? personalEventId;
  const PersonalEventHomePage({
    super.key,
    this.personalEventId,
  });

  @override
  ConsumerState<PersonalEventHomePage> createState() => _PersonalEventHomePageState();
}

class _PersonalEventHomePageState extends ConsumerState<PersonalEventHomePage> {
  bool isFav = false;
  int likesCount = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String audioUrl = '';
  bool _showBanner = false;

  // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialApiCall() async {
    if (widget.personalEventId != null) {
      await ref
          .read(personalEventHomeController)
          .getEvents(eventId: widget.personalEventId!, context: context, ref: ref);
      if (ref
                  .read(personalEventHomeController)
                  .homePersonalEventDetailsModel
                  ?.personalEventThemeName !=
              '' &&
          ref
                  .read(personalEventHomeController)
                  .homePersonalEventDetailsModel
                  ?.personalEventThemeName !=
              null) {
        await ref
            .read(personalEventHomeController)
            .getEventActivity(eventId: widget.personalEventId!, context: context, ref: ref);
      }
      await ref.read(personalEventGuestInviteController).getPersonalEventInvites(
          eventHeaderId: widget.personalEventId!, ref: ref, isLoaderShow: true, context: context);
      ref.watch(personalEventHomeController).setHomePersonalEventInviteModel(
          ref.read(personalEventGuestInviteController).getAllInvitedUsers?.personalEventInviteList);
      // EasyLoading.dismiss();
    }
  }

  apiCalltheUpdateInviteStatus(int inviteStatus) async {
    final result = ref.read(personalEventHomeController).homePersonalEventDetailsModel;
    0;
    await ref.read(personalEventHomeController).updatePersonalEventStatus(
        personalEventInviteId: result!.personalEventInviteId.toString(),
        inviteStatus: inviteStatus,
        context: context,
        ref: ref);
  }

//
  bool isGuestUser = false;
  initialize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initialApiCall();
      final personalEventCtr = ref.watch(personalEventHomeController);
      HomePersonalEventDetailsModel? model1 = personalEventCtr.homePersonalEventDetailsModel;
      likesCount = model1?.likes ?? 0;
      setState(() {});
      var likeUsers =
          ref.read(personalEventHomeController).personalEventLikeUsersModel?.personalEventLikeUsers;
      if (likeUsers == null || likeUsers.isEmpty) {
        await personalEventCtr.getAllPersonalEventLikedUsers(
            eventHeaderId:
                personalEventCtr.homePersonalEventDetailsModel!.personalEventHeaderId!.toString(),
            ref: ref,
            // ignore: use_build_context_synchronously
            context: context); // Exit early to prevent unnecessary execution
      }
      ref
          .read(personalEventHomeController)
          .personalEventLikeUsersModel
          ?.personalEventLikeUsers
          ?.forEach((element) {
        if (element.email == model1!.createdBy!.email) {
          isFav = true;
        } else {
          isFav = false;
          setState(() {});
        }
      });
      likesCount = ref
              .read(personalEventHomeController)
              .personalEventLikeUsersModel
              ?.personalEventLikeUsers
              ?.length ??
          0; //model1?.likes ?? 0;
      audioUrl = model1?.backgroundMusicUrl ?? "";
      if (audioUrl != '') {
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (mounted) {
            setState(() {
              isPlaying = state == PlayerState.playing;
            });
            if (PlayerState.completed == state) {
              _playPause();
            }
          }
        });
        _playPause();
      }
      final inviteCtr = ref.watch(personalEventGuestInviteController);
      await inviteCtr.getPersonalEventInvitesSecondTime(
          eventHeaderId: model1?.personalEventHeaderId.toString() ?? '',
          ref: ref,
          context: context);

      // inviteCtr.getAllInvitedUsers?.weddingInviteList?.forEach((e) {
      //   if (e.email == createEventCtr.userDetailsModel!.email &&
      //       e.inviteStatus == 1) {
      //     inviteCtr.setInvitedStat(true);
      //     inviteCtr.setInvitId(e.weddingInviteId ?? 0);
      //   } else {
      //     inviteCtr.setInvitedStat(false);
      //     inviteCtr.setInvitId(null);
      //   }
      // });
    });

    var userId = PreferenceUtils.getString(PreferenceKey.userId);
    if (userId == 10106.toString()) {
      setState(() {
        isGuestUser = true;
      });
    }
  }

  Future<void> _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(audioUrl));
    }
  }

  Future favClick() async {
    if (isGuestUser) {
      Utility.showAlertMessageForGuestUser(context);
    } else {
      setState(() {
        isFav = !isFav;
        likesCount = isFav == true ? likesCount + 1 : likesCount - 1;
        print('Likes:  $likesCount');
      });
      final personalEventCtr = ref.read(personalEventHomeController);
      print(
          'Personal Event Header ID: ${personalEventCtr.homePersonalEventDetailsModel!.personalEventHeaderId!}');
      await personalEventCtr.likePersonalEvent(
          isUnLike: !isFav,
          personalEventHeaderId:
              personalEventCtr.homePersonalEventDetailsModel!.personalEventHeaderId!,
          likedOn: DateTime.now(),
          ref: ref,
          context: context);

      await personalEventCtr.getAllPersonalEventLikedUsers(
          eventHeaderId:
              personalEventCtr.homePersonalEventDetailsModel!.personalEventHeaderId!.toString(),
          ref: ref,
          context: context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  Future<void> stopPlayer() async {
    await _audioPlayer.pause();
  }

  Future<void> updateInviteStatus() async {
    final personalEventCtr = ref.watch(personalEventHomeController);
    personalEventCtr.homePersonalEventDetailsModel?.inviteStatus = 2;
    setState(() {});
    initialApiCall();
  }

  Route _openEventDetailsAndMomentsScreen() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500), // Animation duration
      pageBuilder: (context, animation, secondaryAnimation) =>
          EventDetailsAndMomentsScreen(isPersonalEvent: true),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1), // Starts from bottom
            end: const Offset(0, 0), // Moves to top
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut, // Smooth animation effect
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final eventCtr = ref.watch(personalEventHomeController);
    HomePersonalEventDetailsModel? personalEventDetailsModel =
        eventCtr.homePersonalEventDetailsModel;
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swipe Up Detected
          final memoriesCtr = ref.watch(personalEventMemoriesController);
          memoriesCtr.personalEventPosts.clear();
          Navigator.of(context).push(_openEventDetailsAndMomentsScreen());
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: eventCtr.isHomeLoading
            ? ShimmerBox(
                // Your full-screen shimmer
                height: 1.sh,
                width: 1.sw,
              )
            :
            // ShimmerWidget(
            //     height: 1.sh,
            //     width: double.infinity,
            //   )
            Stack(
                children: [
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      return Stack(
                        children: [
                          // Network image
                          // CachedNetworkImage(
                          //   imageUrl: personalEventDetailsModel?.backgroundImageUrl ?? "",
                          //   width: 1.sw,
                          //   height: 1.sh,
                          //   fit: BoxFit.fitWidth,
                          // ),
                          CachedRectangularNetworkImageWidget(
                            image: personalEventDetailsModel?.backgroundImageUrl ?? "",
                            width: 1.sw,
                            height: 1.sh,
                            fit: BoxFit.fitHeight,
                          ),
                        ],
                      );
                    },
                  ),
                  Container(
                    width: 1.sw,
                    height: 1.sh,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TAppColors.black.withOpacity(0.8),
                          TAppColors.transparent,
                          TAppColors.black.withOpacity(0.8)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  PersonalEventHomePageTopWidget(
                    stopPlayer: stopPlayer,
                    inviteCallback: updateInviteStatus,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, screenSize.height * 0.07, 0, 0),
                          child: Column(
                            children: [
                              PersonalEventHomePageSideButtons(
                                personalEventHeaderId: int.parse(widget.personalEventId.toString()),
                                isPlaying: isPlaying,
                                playPause: _playPause,
                                isFav: isFav,
                                likes: personalEventDetailsModel?.likes ?? likesCount,
                                favTap: favClick,
                                backgroundMusicUrl: audioUrl,
                              ),
                            ],
                          ),
                        ),
                        AllActivityListWidget(
                          stopPlayer: stopPlayer,
                          favClick: favClick,
                          isFav: isFav,
                          likesCount: personalEventDetailsModel?.likes ?? likesCount,
                          activityCount:
                              personalEventDetailsModel?.personalEventActivityList?.length ?? 0,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 0, screenSize.height * 0.05),
                          child: PersonalEventHomePageNameAndInviteWidget(
                            title: ref
                                    .watch(personalEventHomeController)
                                    .homePersonalEventDetailsModel
                                    ?.title ??
                                "",
                            stopPlayer: stopPlayer,
                            inviteCallback: (p0) {
                              if (p0 == true) {
                                updateInviteStatus();
                              } else {
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
