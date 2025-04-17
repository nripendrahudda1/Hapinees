import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/account/login/login_page.dart';
import 'package:Happinest/modules/account/launch/walkthrough.dart';
import 'package:Happinest/modules/account/login/forgotpassword_page.dart';
import 'package:Happinest/modules/account/login/signup_page.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/views/personal_event_invite_guest_by_email_and_phone_screen.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/views/personal_event_invite_guest_by_search_screen.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/views/personal_event_invite_guest_screen.dart';
import 'package:Happinest/modules/events/activities/views/activity_screen.dart';
import 'package:Happinest/modules/events/e-card/views/personal_event/personal_event_ecard_screen.dart';
import 'package:Happinest/modules/events/edit_activities/views/edit_activity_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/views/create_moments/personal_event/create_personal_event_camera_moment_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/views/create_moments/personal_event/create_personal_event_gallery_moment_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/views/create_moments/personal_event/create_personal_event_text_moment_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/views/home_screen/wedding_event_moments_home_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/views/single_moment_details/personal_event_single_moment_detail_screen.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/views/personal_event_home_page.dart';
import 'package:Happinest/modules/events/update_wedding_event/views/personal_event/update_personal_event_more_info_screen.dart';
import 'package:Happinest/modules/events/update_wedding_event/views/personal_event/update_personal_event_screen.dart';
import '../modules/account/update_profile/update_profile_screen.dart';
import 'package:Happinest/modules/events/create_event/views/create_event_screen.dart';
import 'package:Happinest/modules/events/create_event/views/event_more_info_screen.dart';
import 'package:Happinest/modules/events/edit_ritual/views/edit_ritual_screen.dart';
import 'package:Happinest/modules/events/rituals/views/ritual_screen.dart';
import 'package:Happinest/modules/events/update_wedding_event/views/wedding_event/update_wedding_event_more_info_screen.dart';
import 'package:Happinest/modules/events/update_wedding_event/views/wedding_event/update_wedding_event_screen.dart';
import 'package:Happinest/modules/explore/explore_screen.dart';
import 'package:Happinest/modules/setting%20screen/setting_screen.dart';
import 'package:Happinest/modules/tabbar/bottom_tabbar_screen.dart';
import '../modules/events/Invite_guest/weddinge_event/views/wedding_event_invite_guest_by_search_screen.dart';
import '../modules/events/Invite_guest/weddinge_event/views/wedding_event_invite_guest_screen.dart';
import '../modules/events/Invite_guest/weddinge_event/views/wedding_event_invited_guest_screen.dart';
import '../modules/events/e-card/views/wedding_event/wedding_ecard_screen.dart';
import '../modules/events/event_details_moments/event_moments/views/create_moments/create_wedding_camera_moment_screen.dart';
import '../modules/events/event_details_moments/event_moments/views/create_moments/create_wedding_gallery_moment_screen.dart';
import '../modules/events/event_details_moments/event_moments/views/create_moments/create_wedding_text_moment_screen.dart';
import '../modules/events/event_details_moments/event_moments/views/comment_screen/wedding_event_moments_comments_screen.dart';
import '../modules/events/event_details_moments/event_moments/views/create_moments/personal_event/update_personal_event_gallery_moment_screen.dart';
import '../modules/events/event_details_moments/event_moments/views/create_moments/personal_event/update_personal_event_text_moment_screen.dart';
import '../modules/events/event_details_moments/event_moments/views/single_moment_details/occasion_single_moment_detail_screen.dart';
import '../modules/events/event_details_moments/views/event_details_and_moments_screen.dart';
import '../modules/events/event_homepage/wedding_event/views/wedding_event_homepage.dart';

class Routes {
  static const String splashRoute = '/splash';
  static const String walkthrough = '/walkthrough';
  static const String loginRoute = '/login_page';
  static const String singupRoute = '/signup_page';
  static const String verifyEmailRoute = '/verify_email';
  static const String forgotPasswordRoute = '/forgotpassword_page';
  static const String homeRoute = '/home_screen';
  static const String profileRoute = '/profile';
  // static const String memoriesRoute = '/memories_screen';
  // static const String dayWiseStories = '/day_wise_stories';
  // static const String editMemories = '/edit_memories';
  // static const String editDay = '/edit_day';
  // static const String manageLocation = '/manage_location';
  static const String bulkImagePicker = '/BulkImagePicker';

  static const String userprofilescreen = '/user_profile';

  static const String createEventScreen = '/createEventScreen';
  static const String eventMoreInfoScreen = '/eventMoreInfoScreen';
  static const String weddingEventHomePageScreen = '/wedding_event_homepage';
  static const String personalEventHomePageScreen = "/personal_event_homepage";
  static const String eventCommentsScreen = '/eventCommentsScreen';
  static const String editRitualScreen = '/editRitualScreen';
  static const String editActivityScreen = '/editActivityScreen';
  static const String updateWeddingEventScreen = '/updateWeddingEventScreen';
  static const String updatePersonalEventScreen = '/updatePersonalEventScreen';
  static const String updateWeddingEventMoreInfoScreen = '/updateWeddingEventMoreInfoScreen';
  static const String updatePersonalEventMoreInfoScreen = '/updatePersonalEventMoreInfoScreen';
  // static const String memoriesOnMap = '/memories_on_map';
  static const String eventDetailsAndMomentsScreen = '/eventDetailsAndMomentsScreen';
  static const String weddingDetailsAndMomentsScreen = '/weddingDetailsAndMomentsScreen';

  static const String weddingEventInvitedGuestScreen = '/weddingEventInvitedGuestScreen';
  static const String personalEventInvitedGuestScreen = '/personalEventInvitedGuestScreen';
  static const String weddingEventInviteGuestScreen = '/weddingEventInviteGuestScreen';
  static const String personalEventInviteGuestScreen = '/personalEventInviteGuestScreen';
  static const String exploreScreen = '/exploreScreen';
  static const String weddingEventInviteGuestBySearchScreen =
      '/weddingEventInviteGuestBySearchScreen';
  static const String personalEventInviteGuestBySearchScreen =
      '/personalEventInviteGuestBySearchScreen';
  static const String eventRitualScreen = '/eventRitualScreen';
  static const String eventRitualForward = '/eventRitualForward';
  static const String eventRitualBackward = '/eventRitualBackward';
  static const String weddingECardScreen = '/weddingECardScreen';
  static const String personalEventECardScreen = '/personalEventECardScreen';
  // static const String eventRitualCommentsScreen = '/eventRitualCommentsScreen';
  // static const String editEcard = '/editEcard';
  // static const String previewECard = '/previewECard';
  // static const String timelineScreen = '/timelineScreen';
  static const String eventActivityScreen = '/eventActivityScreen';
  static const String eventActivityForward = '/eventActivityForward';
  static const String eventActivityBackward = '/eventActivityBackward';

  static const String momentsCommentsScreen = '/momentsCommentsScreen';

  static const String occasionSingleMomentDetailScreen = '/occasionSingleMomentDetailScreen';
  static const String personalEventSingleMomentDetailScreen =
      '/personalEventSingleMomentDetailScreen';
  static const String createWeddingCameraMomentScreen = '/createWeddingCameraMomentScreen';
  static const String createPersonalEventCameraMomentScreen =
      '/createPersonalEventCameraMomentScreen';
  static const String createWeddingGalleryMomentScreen = '/createWeddingGalleryMomentScreen';
  static const String createPersonalEventGalleryMomentScreen =
      '/createPersonalEventGalleryMomentScreen';
  static const String createWeddingTextMomentScreen = '/createWeddingTextMomentScreen';
  static const String createPersonalEventTextMomentScreen = '/createPersonalEventTextMomentScreen';

  static const String updatePersonalEventTextMomentScreen = '/updatePersonalEventTextMomentScreen';
  static const String updatePersonalEventGalleryMomentScreen =
      '/  updatePersonalEventGalleryMomentScreen';

  static const String settingScreen = '/settingScreen';
}

class TRouter {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case Routes.walkthrough:
        return MaterialPageRoute(builder: (_) => const TWalkthrough());
      case Routes.loginRoute:
        final args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => LoginPage(
                  emailText: (args is Map<String, dynamic>) ? args['emailText'] : null,
                ),
            settings: RouteSettings(arguments: settings.arguments));
      case Routes.singupRoute:
        return MaterialPageRoute(
            builder: (_) => const SignUpPage(),
            settings: RouteSettings(arguments: settings.arguments));
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case Routes.homeRoute:
        if (settings.name == Routes.homeRoute) {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (_) => BottomTabBarScreen(
              initialIndex: args?['index'] ?? 0, // Default to 0 if null
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const BottomTabBarScreen());

      case Routes.profileRoute:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());
      // case Routes.manageLocation:
      //   return MaterialPageRoute(
      //       builder: (_) => const ManageLocation(),
      //       settings: RouteSettings(arguments: settings.arguments));

      case Routes.createEventScreen:
        return MaterialPageRoute(builder: (_) => const CreateEventScreen());
      case Routes.eventMoreInfoScreen:
        return MaterialPageRoute(builder: (_) => const EventMoreInfoScreen());
      case Routes.weddingEventHomePageScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => WeddingEventHomePage(
                  weddingId: args['weddingId'],
                ));
      case Routes.personalEventHomePageScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PersonalEventHomePage(
            personalEventId: args['personalEventId'],
          ),
        );

      case Routes.weddingECardScreen:
        // final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => const WeddingECardScreen());
      case Routes.bulkImagePicker:
      // final args = settings.arguments as Map<String, dynamic>;

      case Routes.personalEventECardScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PersonalEventECardScreen(
                  isSingleImage: args['isSingleImage'],
                ));
      // case Routes.eventCommentsScreen:
      //   return MaterialPageRoute(builder: (_) => const EventCommentsScreen());
      case Routes.editRitualScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) {
          return EditRitualScreen(
            homeWeddingDetailsModel: args['homeWeddingDetailsModel'],
            ritualIndex: args['ritualIndex'],
          );
        });
      case Routes.editActivityScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) {
          return EditActivityScreen(
            homePersonalEventDetailsModel: args['homePersonalEventDetailsModel'],
            activityIndex: args['activityIndex'],
          );
        });
      case Routes.updateWeddingEventScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) {
          return UpdateWeddingEventScreen(
            homeModel: args['homeModel'],
          );
        });
      case Routes.updatePersonalEventScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) {
          return UpdatePersonalEventScreen(
            homeModel: args['homeModel'],
          );
        });
      case Routes.updateWeddingEventMoreInfoScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) {
          return UpdateWeddingEventMoreInfoScreen(
            homeModel: args['homeModel'],
          );
        });
      case Routes.updatePersonalEventMoreInfoScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) {
          return UpdatePersonalEventMoreInfoScreen(
            homeModel: args['homeModel'],
          );
        });
      case Routes.eventDetailsAndMomentsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => EventDetailsAndMomentsScreen(
                  isPersonalEvent: args['isPersonalEvent'],
                ));

      case Routes.weddingDetailsAndMomentsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => WeddingEventMomentsHomeScreen(
                //isPersonalEvent: args['isPersonalEvent'],
                ));

      case Routes.exploreScreen:
        return MaterialPageRoute(builder: (_) => const ExploreScreen());
      case Routes.weddingEventInvitedGuestScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => WeddingEventInvitedGuestScreen(
                  title: args['title'],
                ));
      case Routes.personalEventInvitedGuestScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PersonalEventInvitedGuestScreen(
                  title: args['title'],
                ));
      case Routes.weddingEventInviteGuestScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => WeddingEventInviteGuestScreen(
                  title: args['title'],
                ));
      case Routes.personalEventInviteGuestScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PersonalEventInviteGuestByEmailAndContactScreen(
                  title: args['title'],
                ));
      case Routes.weddingEventInviteGuestBySearchScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildBottomUpRoute(WeddingEventInviteGuestBySearchScreen(
          searchCtr: args['searchCtr'],
        ));
      case Routes.personalEventInviteGuestBySearchScreen:
        return _buildBottomUpRoute(const PersonalEventInviteGuestBySearchScreen());
      case Routes.eventRitualScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) {
          return RitualScreen(
            homeWeddingDetailsModel: args['homeWeddingDetailsModel'],
            ritualIndex: args['ritualIndex'],
            ritualModels: args['ritualModels'],
          );
        });

      case Routes.eventRitualBackward:
        final args = settings.arguments as Map<String, dynamic>;
        return leftToRight(
            RitualScreen(
              homeWeddingDetailsModel: args['homeWeddingDetailsModel'],
              ritualIndex: args['ritualIndex'],
              ritualModels: args['ritualModels'],
            ),
            400);

      case Routes.eventRitualForward:
        final args = settings.arguments as Map<String, dynamic>;
        return rightToLeft(
            RitualScreen(
              homeWeddingDetailsModel: args['homeWeddingDetailsModel'],
              ritualIndex: args['ritualIndex'],
              ritualModels: args['ritualModels'],
            ),
            400);

      case Routes.eventActivityScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) {
            return ActivityScreen(
              homePersonalEventDetailsModel: args['homePersonalEventDetailsModel'],
              activityIndex: args['activityIndex'],
              activityModels: args['activityModels'],
              favClick: args['favClick'],
              isFav: args['isFav'],
              likesCount: args['likesCount'],
            );
          },
        );

      case Routes.eventActivityBackward:
        final args = settings.arguments as Map<String, dynamic>;
        return leftToRight(
            ActivityScreen(
              homePersonalEventDetailsModel: args['homePersonalEventDetailsModel'],
              activityIndex: args['activityIndex'],
              activityModels: args['activityModels'],
              favClick: args['favClick'],
              isFav: args['isFav'],
              likesCount: args['likesCount'],
            ),
            400);

      case Routes.eventActivityForward:
        final args = settings.arguments as Map<String, dynamic>;
        return rightToLeft(
            ActivityScreen(
              homePersonalEventDetailsModel: args['homePersonalEventDetailsModel'],
              activityIndex: args['activityIndex'],
              activityModels: args['activityModels'],
              favClick: args['favClick'],
              isFav: args['isFav'],
              likesCount: args['likesCount'],
            ),
            400);

      // case Routes.eventRitualCommentsScreen:
      //   return MaterialPageRoute(builder: (_) => const RitualCommentsScreen());
      case Routes.momentsCommentsScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => WeddingEventMomentPostCommentSection(
                  occasionPostId: arguments['occasionPostId'],
                  token: arguments['token'],
                ));
      case Routes.occasionSingleMomentDetailScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => OccasionSingleMomentDetailScreen(
                  postModel: arguments['postModel'],
                  token: arguments['token'],
                ));
      case Routes.personalEventSingleMomentDetailScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PersonalEventSingleMomentDetailScreen(
                  postModel: arguments['postModel'],
                  token: arguments['token'],
                  selectedImageIndex: arguments['selectedIndex'],
                ));
      case Routes.createWeddingCameraMomentScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CreateWeddingCameraMomentScreen(
                  imagePath: arguments['imagePath'],
                  token: arguments['token'],
                  eventHeaderId: arguments['eventHeaderId'],
                  eventTitle: arguments['eventTitle'],
                ));
      case Routes.createPersonalEventCameraMomentScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CreatePersonalEventCameraMomentScreen(
                  imagePath: arguments['imagePath'],
                  token: arguments['token'],
                  eventHeaderId: arguments['eventHeaderId'],
                  eventTitle: arguments['eventTitle'],
                ));
      case Routes.createWeddingGalleryMomentScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CreateWeddingGalleryMomentScreen(
                  imagePaths: arguments['imagePaths'],
                  token: arguments['token'],
                  eventHeaderId: arguments['eventHeaderId'],
                  eventTitle: arguments['eventTitle'],
                ));
      case Routes.createPersonalEventGalleryMomentScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CreatePersonalEventGalleryMomentScreen(
                  imagePaths: arguments['imagePaths'],
                  token: arguments['token'],
                  eventHeaderId: arguments['eventHeaderId'],
                  eventTitle: arguments['eventTitle'],
                ));
      case Routes.createWeddingTextMomentScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CreateWeddingTextMomentScreen(
                  token: arguments['token'],
                  eventHeaderId: arguments['eventHeaderId'],
                  eventTitle: arguments['eventTitle'],
                ));
      case Routes.createPersonalEventTextMomentScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CreatePersonalEventTextMomentScreen(
                  token: arguments['token'],
                  eventHeaderId: arguments['eventHeaderId'],
                  eventTitle: arguments['eventTitle'],
                ));
      case Routes.updatePersonalEventTextMomentScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => UpdatePersonalEventTextMomentScreen(
                  postModel: arguments['postModel'],
                  token: arguments['token'],
                  eventHeaderId: arguments['eventHeaderId'],
                  eventTitle: arguments['eventTitle'],
                ));
      case Routes.updatePersonalEventGalleryMomentScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => UpdatePersonalEventGalleryMomentScreen(
                postModel: arguments['postModel'],
                token: arguments['token'],
                eventHeaderId: arguments['eventHeaderId'],
                eventTitle: arguments['eventTitle'],
                imagePaths: arguments['imagePaths']));

      case Routes.settingScreen:
        return MaterialPageRoute(
            builder: (_) => const SettingScreen(),
            settings: RouteSettings(arguments: settings.arguments));
      case Routes.userprofilescreen:
        return MaterialPageRoute(
          builder: (context) => const UserProfileScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }

  static _buildBottomUpRoute(Widget widget, {int? duration = 600}) {
    return bottomUpRoute(widget, duration);
  }
}

Route bottomUpRoute(Widget page, [int? duration]) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: duration ?? 0),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, 0.5);
      const end = Offset.zero;
      const curve = Curves.linear;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route rightToLeft(Widget page, [int? duration]) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: duration ?? 0),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.linear;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route leftToRight(Widget page, [int? duration]) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: duration ?? 0),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1, 0);
      const end = Offset.zero;
      const curve = Curves.linear;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
