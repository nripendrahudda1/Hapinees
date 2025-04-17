import 'package:Happinest/common/common_default_apis.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_retangular_network_image.dart';
import 'package:Happinest/utility/constants/images/image_url.dart';
import '../../../../../common/widgets/loading_images_shimmer.dart';
import '../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../../Invite_guest/weddinge_event/controller/wedding_invite_guests_controller.dart';
import '../../../event_details_moments/views/event_details_and_moments_screen.dart';
import '../controller/wedding_event_home_controller.dart';
import '../widgets/all_rituals_list_widget.dart';
import '../widgets/wedding_event_home_page_name_and_invite_widget.dart';
import '../widgets/wedding_event_home_page_top_widget.dart';
import '../widgets/wedding_event_homepage_side_buttons.dart';

class WeddingEventHomePage extends ConsumerStatefulWidget {
  final String? weddingId;
  const WeddingEventHomePage({
    super.key,
    this.weddingId,
  });

  @override
  ConsumerState<WeddingEventHomePage> createState() => _WeddingEventHomePageState();
}

class _WeddingEventHomePageState extends ConsumerState<WeddingEventHomePage> {
  bool isFav = false;
  int likesCount = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String audioUrl = '';
  // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initialApiCall() async {
    if (widget.weddingId != null) {
      ref.read(weddingEventHomeController).setHomeLoading(true);
      await ref.read(weddingEventHomeController).getWedding(
            weddingId: widget.weddingId!,
            context: context,
            ref: ref,
          );
    }
  }

  bool isGuestUser = false;
  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initialApiCall();
      final weddingEventCtr = ref.watch(weddingEventHomeController);
      print('User type: ${weddingEventCtr.userRoleEnum.name}');
      HomeWeddingDetailsModel? model1 = weddingEventCtr.homeWeddingDetails;
      likesCount = model1?.likes ?? 0;
      setState(() {});
      ref
          .read(weddingEventHomeController)
          .weddingLikeUsersModel
          ?.weddingLikeUsers
          ?.forEach((element) {
        if (element.email == weddingEventCtr.homeWeddingDetails!.createdBy!.email) {
          setState(() {
            isFav = true;
            //likesCount = isFav == true ? likesCount + 1 : likesCount - 1;
          });
        } else {
          isFav = false;
          setState(() {});
        }
      });
      // likesCount = model?.likes  ?? 0;

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
      final inviteCtr = ref.watch(weddingEventGuestInviteController);
      await inviteCtr.getWeddingInvitesSecondTime(
          weddingHeaderId: model1?.weddingHeaderId.toString() ?? '', ref: ref, context: context);

      inviteCtr.getAllInvitedUsers?.weddingInviteList?.forEach((e) {
        if (e.email == myProfileData!.email && e.inviteStatus == 1) {
          inviteCtr.setInvitedStat(true);
          inviteCtr.setInvitId(e.weddingInviteId ?? 0);
        } else {
          inviteCtr.setInvitedStat(false);
          inviteCtr.setInvitId(null);
        }
      });
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
      print(
          'Wedding Header ID: ${ref.read(weddingEventHomeController).homeWeddingDetails!.weddingHeaderId!}');
      await ref.read(weddingEventHomeController).likeWeddingEvent(
          isUnLike: !isFav,
          weddingHeaderId:
              ref.read(weddingEventHomeController).homeWeddingDetails!.weddingHeaderId!,
          likedOn: DateTime.now(),
          ref: ref,
          context: context);

      await ref.read(weddingEventHomeController).getAllWeddingLikedUsers(
          weddingHeaderId:
              ref.read(weddingEventHomeController).homeWeddingDetails!.weddingHeaderId!.toString(),
          ref: ref,
          context: context);
    }
  }

  // favClick() {
  //   setState(() {
  //     isFav = !isFav;
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  Future<void> stopPlayer() async {
    await _audioPlayer.pause();
  }

  Route _openEventDetailsAndMomentsScreen() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500), // Animation duration
      pageBuilder: (context, animation, secondaryAnimation) =>
          EventDetailsAndMomentsScreen(isPersonalEvent: false),
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
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swipe Up Detected
          Navigator.of(context).push(_openEventDetailsAndMomentsScreen());
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ref.watch(weddingEventHomeController).isHomeLoading
            ? const ShimmerWidget()
            : Stack(
                children: [
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final weddingCtr = ref.watch(weddingEventHomeController);
                      print(weddingCtr.homeWeddingDetails?.weddingHeaderId);
                      return CachedRectangularNetworkImageWidget(
                        image: weddingCtr.homeWeddingDetails?.backgroundImageUrl ??
                            TImageUrl.eventHomeBgUrl,
                        width: 1.sw,
                        height: 1.sh,
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
                  WeddingEventHomePageTopWidget(
                    stopPlayer: stopPlayer,
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
                              WeddingEventHomePageSideButtons(
                                weddingHeaderId: int.parse(widget.weddingId.toString()),
                                isPlaying: isPlaying,
                                playPause: _playPause,
                                isFav: isFav,
                                likes: likesCount,
                                favTap: favClick,
                                backgroundMusicUrl: audioUrl,
                              ),
                              // AllEventsRituals(stopPlayer: stopPlayer,),
                            ],
                          ),
                        ),
                        AllRitualListWidget(stopPlayer: stopPlayer),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 0, screenSize.height * 0.05),
                          child: WeddingEventHomePageNameAndInviteWidget(
                            title:
                                ref.watch(weddingEventHomeController).homeWeddingDetails?.title ??
                                    "",
                            stopPlayer: stopPlayer,
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
