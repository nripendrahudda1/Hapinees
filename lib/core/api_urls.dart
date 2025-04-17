import 'package:flutter_dotenv/flutter_dotenv.dart';

Map<String, dynamic> header({required String authToken, required String contentType}) {
  return {
    'Authorization': authToken,
    'Content-Type': contentType,
  };
}

class ApiUrl {
  static String contentTypeHeader = dotenv.get('CONTENT_TYPE_HEADER');
  static String baseURL = dotenv.get('BASE_URL');
  static String urlPathWithoutFolderName = dotenv.get('URL_PATH');
  static String updateDeviceToken = dotenv.get('API_UpdateDeviceToken');
  static String getCompanySetting = dotenv.get('API_GetCompanySetting');

  // ##################################### auth ####################################
  static String authentication = dotenv.get('API_AUTHENTICATION');
  static String signUp = dotenv.get('API_SIGNUP');
  static String getOtp = dotenv.get('API_GetOTP');
  static String signIn = dotenv.get('API_SIGNIN');
  static String logout = dotenv.get('API_Logout');
  static String resetPassword = dotenv.get('API_RESET_PASSWORD');
  static String changePassword = dotenv.get('API_ChangePassword');
  static String deleteAccount = dotenv.get('API_DeleteAccount');

  // ##################################### profile ####################################
  static String updateUserProfile = dotenv.get('API_UPDATE_USER_PROFILE');
  static String updateBackgroundPicture = dotenv.get('API_UPDATE_BACKGROUND_PROFILE');
  static String updateUserPicture = dotenv.get('API_UPDATE_PROFILE_PICTURE');
  static String getProfilePicture = dotenv.get('API_GetProfilePicture');
  static String getUserDetails = dotenv.get('API_GetUserDetail');
  static String getStories = dotenv.get('API_GetStories'); // profile screen in event in add
  // ######## follow & following ---------
  static String getFollowersDetails = dotenv.get('API_GetFollowersDetail');
  static String getFollowingDetails = dotenv.get('API_GetUserFollowingDetail');
  static String followUser = dotenv.get('API_FollowUser');
  static String deleteFollowerUser = dotenv.get('API_DeleteFollowerUser');
  static String getUserFollowersFollowing = dotenv.get('Api_GetFollowerFollowing');

  // ##################################### notification ####################################
  static String sendPushNotification = dotenv.get('API_SendPush_Notification');
  static String addNotification = dotenv.get('AddNotification');
  static String readOnlyGetNotification = dotenv.get('API_ReadOnly_GetNotification');
  static String getNotificationType = dotenv.get('API_GetNotification_Type');
  static String getUnReadNotification = dotenv.get('API_UnRead_Notification');
  static String reedUnReedNotificationGet = dotenv.get('API_ReadUnReadNotification');
  static String getUserNotificationDetail = dotenv.get('API_GetUserNotificationsDetail');
  static String getNotifications = dotenv.get('API_GetNotification');
  static String updateUserNotificationSetting = dotenv.get('API_UpdateUserNotificationSetting');

  // ##################################### feedback ####################################
  static String sendFeedback = dotenv.get('API_SendFeedback');
  static String feedbackDetails = dotenv.get('API_FeedbackDetail');

  // ##################################### tool tip ####################################
  static String getOnScreenToolTip = dotenv.get('API_GetToolTip');
  static String markReadOnScreenToolTip = dotenv.get('API_MarkRead_ToolTip');
  static String resetOnScreenToolTip = dotenv.get('API_Reset_ToolTip');

  // ##################################### author ####################################
  static String getPopularAuthor = dotenv.get('API_GetPopularAuthor');

  // ##################################### dashboard search APi   ####################################
  static String searchOccasion = dotenv.get('API_SearchOccasionStories');
  static String searchTravel = dotenv.get('API_SearchTravelStories');
  static String searchAuthor = dotenv.get('API_SearchAuthor');

  // ##################################### dashboard story collection api  ####################################
  static String getGetEventModules = dotenv.get('GetEventModules');
  static String getEventGroups = dotenv.get('API_GetEventGroup');

  // ##################################### dashboard story collection api  ####################################
  static String getLocationApi = dotenv.get('API_GetLocations');

  // #####################################*************---- event ----*************####################################
  static String event = dotenv.get('API_Event');
  static String getEvents = dotenv.get('API_GetEvent');
  static String addEventView = dotenv.get('API_AddEventView');
  static String getEventDetail = dotenv.get('API_GetEventDetail');
  static String setEventGroup = dotenv.get('API_SetEventGroup');
  static String updateEventGroup = dotenv.get('API_UpdateEventGroup');
  static String getEventTypesMaster = dotenv.get('API_GetEventTypesMaster');
  static String setEventType = dotenv.get('API_SetEventTypes');
  static String updateEventType = dotenv.get('API_UpdateEventTypes');
  static String addEventLike = dotenv.get('API_AddEventLike');
  static String addEventTipsLike = dotenv.get('API_AddEventTipsLike');
  static String addCampaignVote = dotenv.get('API_AddCampaignVote');
  static String getCampaignVote = dotenv.get('API_GetCampaignVotes');
  static String getCampaignByEventId = dotenv.get('API_GetCampaign_By_EventId');
  static String getCampaignByCampaignId = dotenv.get('API_GetCampaign_By_CampaignId');
  static String getCampaignLeaderBoard = dotenv.get('API_GetCampaignLeaderboard');

  // #####################################**************---- occasion ----*************####################################
  static String occasion = dotenv.get('API_OCCASION');
  static String getDashBoardOccasion = dotenv.get('API_GET_DASHBOARD_OCCASION');
  // ######## post [moment post] ---------
  static String getOccasionPost = dotenv.get('API_GET_OCCASION_POST');
  static String setOccasionPost = dotenv.get('API_SET_OCCASION_POST');
  static String updateOccasionPost = dotenv.get('API_UPDATE_OCCASION_POST');
  static String deleteOccasionPost = dotenv.get('API_DELETE_OCCASION_POST');
  static String hideOccasionPost = dotenv.get('API_HIDE_OCCASION_POST');
  static String setOccasionPostMedia = dotenv.get('API_SET_OCCASION_POST_MEDIA');
  static String deleteOccasionPostMedia = dotenv.get('API_DELETE_OCCASION_POST_MEDIA');
  static String setPostMediaForRitual = dotenv.get('API_SET_POST_MEDIA_FOR_RITUAL');
  static String removePostMediaForRitual = dotenv.get('API_REMOVE_POST_MEDIA_FROM_RITUAL');
  static String getOccasionPostBackGroundMaster =
      dotenv.get('API_GET_OCCASION_POST_BACKGROUND_MASTER');
  static String getOccasionPostLikeUsers = dotenv.get('API_GET_OCCASION_POST_LIKE_USER');
  static String setOccasionPostLike = dotenv.get('API_SET_OCCASION_POST_LIKE');
  static String getOccasionPostComment = dotenv.get('API_GET_OCCASION_POST_COMMENT');
  static String setOccasionPostComment = dotenv.get('API_SET_OCCASION_POST_COMMENT');
  static String setOccasionPostCommentLike = dotenv.get('API_SET_OCCASION_POST_COMMENT_LIKE');

  // ##################################### wedding event ####################################
  static String redeemEventCode = dotenv.get('RedeemEventCode');
  static String weddingEvent = dotenv.get('WeddingEvent');
  static String setWedding = dotenv.get('SetWedding');
  static String getWedding = dotenv.get('GetWedding');
  static String getWeddings = dotenv.get('GetWeddings');
  static String updateWedding = dotenv.get('UpdateWedding');
  static String deleteWedding = dotenv.get('DeleteWedding');
  static String getWeddingPhoto = dotenv.get('GetWeddingPhotos');
  static String generateWeddingVideo = dotenv.get('GenerateWeddingVideo');
  static String makeWeddingCoHost = dotenv.get('MakeWeddingCoHost');
  // ######## wedding event like ---------
  static String getWeddingLikeUsers = dotenv.get('GetWeddingLikeUsers');
  static String setWeddingLike = dotenv.get('SetWeddingLike');
  // ######## wedding event view ---------
  static String getWeddingViewUsers = dotenv.get('GetWeddingViewUsers');
  static String setWeddingView = dotenv.get('SetWeddingView');
  // ######## wedding event comment ---------
  static String getWeddingComments = dotenv.get('GetWeddingComments');
  static String setWeddingComment = dotenv.get('SetWeddingComment');
  static String updateWeddingComment = dotenv.get('UpdateWeddingComment');
  static String setWeddingCommentLike = dotenv.get('SetWeddingCommentLike');
  // ######## wedding style  ---------
  static String getWeddingStyleMasters = dotenv.get('GetWeddingStyleMasters');
  static String setWeddingStyleMaster = dotenv.get('SetWeddingStyleMaster');
  static String updateWeddingStyleMaster = dotenv.get('UpdateWeddingStyleMaster');
  // ######## wedding ritual ---------
  static String getWeddingRitualMasters = dotenv.get('GetWeddingRitualMasters');
  static String setWeddingRitualMaster = dotenv.get('SetWeddingRitualMaster');
  static String updateWeddingRitualMaster = dotenv.get('UpdateWeddingRitualMaster');
  static String getWeddingRituals = dotenv.get('GetWeddingRituals');
  static String setWeddingRitual = dotenv.get('SetWeddingRitual');
  static String updateWeddingRitual = dotenv.get('UpdateWeddingRitual');
  static String deleteWeddingRitual = dotenv.get('DeleteWeddingRitual');
  static String getWeddingRitualPhoto = dotenv.get('GetWeddingRitualPhoto');
  static String setWeddingRitualPhoto = dotenv.get('setWeddingRitualPhoto');
  static String deleteWeddingRitualPhoto = dotenv.get('DeleteWeddingRitualPhoto');
  // ######## ritual comment ---------
  static String getRitualPhotoComments = dotenv.get('GetRitualPhotoComments');
  static String setRitualPhotoComment = dotenv.get('SetRitualPhotoComment');
  static String updateRitualPhotoComment = dotenv.get('UpdateRitualPhotoComment');
  static String setRitualPhotoCommentLike = dotenv.get('SetRitualPhotoCommentLike');
  // ######## ritual like ---------
  static String getRitualPhotoLikeUsers = dotenv.get('GetRitualPhotoLikeUsers');
  static String setRitualPhotoLike = dotenv.get('SetRitualPhotoLike');
  // ######## wedding invites ---------
  static String getWeddingInvites = dotenv.get('GetWeddingInvites');
  static String setWeddingInvite = dotenv.get('SetWeddingInvite');
  static String searchWeddingInvite = dotenv.get('SearchWeddingInvite');
  static String actionOnWeddingInvite = dotenv.get('ActionOnWeddingInvite');
  // ##
  static String getEventTypeMasters = dotenv.get('GetEventTypeMasters');
  static String setEventTypeMaster = dotenv.get('SetEventTypeMaster');
  static String updateEventTypeMaster = dotenv.get('UpdateEventTypeMaster');
  static String setEventGroupMaster = dotenv.get('SetEventGroupMaster');
  static String updateEventGroupMaster = dotenv.get('UpdateEventGroupMaster');

  // ##################################### personal event ####################################
  static String personalEvent = dotenv.get('PersonalEvent');
  static String setPersonalEvent = dotenv.get('SetPersonalEvent');
  static String getPersonalEvent = dotenv.get('GetPersonalEvent');
  static String updatePersonalEvent = dotenv.get('UpdatePersonalEvent');
  static String deletePersonalEvent = dotenv.get('DeletePersonalEvent');
  static String getPersonalEvents = dotenv.get('GetPersonalEvents');
  static String getPersonalEventPhotos = dotenv.get('GetPersonalEventPhotos');
  static String generatePersonalEventVideo = dotenv.get('GeneratePersonalEventVideo');
  static String makePersonalEventCoHost = dotenv.get('MakePersonalEventCoHost');
  // ######## personal event like ---------
  static String getPersonalEventLikeUsers = dotenv.get('GetPersonalEventLikeUsers');
  static String setPersonalEventLike = dotenv.get('SetPersonalEventLike');
  // ######## personal event view ---------
  static String getPersonalEventViewUsers = dotenv.get('GetPersonalEventViewUsers');
  static String setPersonalEventView = dotenv.get('SetPersonalEventView');
  // ######## personal event comment ---------
  static String getPersonalEventComments = dotenv.get('GetPersonalEventComments');
  static String setPersonalEventComment = dotenv.get('SetPersonalEventComment');
  static String setPersonalEventCommentLike = dotenv.get('SetPersonalEventCommentLike');
  // ######## personalEvent theme ---------
  static String getPersonalEventThemesMaster = dotenv.get('GetPersonalEventThemesMaster');
  static String setPersonalEventThemeMaster = dotenv.get('SetPersonalEventThemeMaster');
  // ######## personalEvent get them activity ---------
  static String setPersonalEventActivitiesMaster = dotenv.get('SetPersonalEventActivityMaster');
  static String getPersonalEventActivityMasters = dotenv.get('GetPersonalEventActivityMasters');
  // ######## personalEvent set activity ---------
  static String getPersonalEventActivities = dotenv.get('GetPersonalEventActivities');
  static String setPersonalEventActivity = dotenv.get('SetPersonalEventActivity');
  static String updatePersonalEventActivity = dotenv.get('UpdatePersonalEventActivity');
  static String deletePersonalEventActivity = dotenv.get('DeletePersonalEventActivity');
  static String getPersonalEventActivityPhoto = dotenv.get('GetPersonalEventActivityPhoto');
  static String setPersonalEventActivityPhoto = dotenv.get('SetEventActivityPhoto');
  static String deletePersonalEventActivityPhoto = dotenv.get('DeletePersonalEventActivityPhoto');
  // ######## activity like ---------
  static String setActivityPhotoLike = dotenv.get('SetActivityPhotoLike');
  static String getActivityPhotoLikeUsers = dotenv.get('GetActivityPhotoLikeUsers');
  // ######## activity comment ---------
  // static String setActivityPhotoComment  = dotenv.get('SetActivityPhotoComment');
  // static String getActivityPhotoComments  = dotenv.get('GetActivityPhotoComments');
  // static String setActivityPhotoCommentLike  = dotenv.get('SetActivityPhotoCommentLike');
  // ######## personal event invites ---------
  static String getPersonalEventInvites = dotenv.get('GetPersonalEventInvites');
  static String searchPersonalEventInvite = dotenv.get('SearchPersonalEventInvite');
  static String setPersonalEventInvite = dotenv.get('SetPersonalEventInvite');
  static String actionOnPersonalEventInvite = dotenv.get('ActionOnPersonalEventInvite');
  // ######## personal event post ---------
  static String getPersonalEventPosts = dotenv.get('GET_PERSONAL_EVENT_POSTS');
  static String setPersonalEventPost = dotenv.get('SET_EVENT_POST');
  static String updatePersonalEventPost = dotenv.get('UPDATE_PERSONAL_EVENT_POST');
  static String setPersonalEventPostPhoto = dotenv.get('SET_EVENT_POST_PHOTO');
  static String getPersonalEventPostLikeUsers = dotenv.get('GET_PERSONAL_EVENT_POST_LIKE_USERS');
  static String setPersonalEventPostLike = dotenv.get('SET_PERSONAL_EVENT_POST_LIKE');
  static String getPersonalEventPostComments = dotenv.get('GET_PERSONAL_EVENT_POST_COMMENTS');
  static String setPersonalEventPostComment = dotenv.get('SET_PERSONAL_EVENT_POST_COMMENT');
  static String setPersonalEventPostCommentLike =
      dotenv.get('SET_PERSONAL_EVENT_POST_COMMENT_LIKE');
  static String deletePersonalEventPost = dotenv.get('DELETE_PERSONAL_EVENT_POST');
  static String getEmailTemplate = dotenv.get('EMAIL_TEMPLATE');
   static String sendEmailTemplate = dotenv.get('EMAIL_SEND_TEMPLATE');
  static String getEmailTemplateController = dotenv.get('EMAIL_CONTROLLR');

  //----- UPDATE personal ENVITE Status and Delete Moments Photos
  static String updatePersonalEventStatus = dotenv.get('UPDATE_PERSONAL_EVENT_INVITE_STATUS');
  static String deletePersonalEventPostPhoto = dotenv.get('DELETE_PERSONAL_EVENT_POST_PHOTO');

  // ################################################################################################
  // #### Travelory App APIS
  // ################################################################################################
  static String getEventCategoryMasters = dotenv.get('GetEventCategoryMasters');
}


// API_ActionFollowerRequest api issue