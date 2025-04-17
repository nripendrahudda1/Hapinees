import 'package:Happinest/modules/profile/model/stories_model.dart';

class FollowUserModel {
  num? requestId;
  int? followersCount;
  int? followingCount;
  UserModelClass? userDetail;
  FollowUserModel({this.requestId, this.userDetail, this.followersCount, this.followingCount});

  FollowUserModel.fromJson(Map<String, dynamic> json) {
    followersCount = json["followersCount"];
    followingCount = json["followingCount"];
    requestId = json['requestId'];
    userDetail = json['userDetail'] != null ? UserModelClass.fromJson(json['userDetail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    if (userDetail != null) {
      data['userDetail'] = userDetail!.toJson();
    }
    return data;
  }
}
