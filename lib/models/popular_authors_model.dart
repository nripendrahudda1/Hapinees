
import '../modules/profile/model/stories_model.dart';

class PopulerAuthorsModel {
  List<Authors>? authors;
  bool? responseStatus;
  dynamic validationMessage;
  int? statusCode;

  PopulerAuthorsModel(
      {this.authors,
      this.responseStatus,
      this.validationMessage,
      this.statusCode});

  PopulerAuthorsModel.fromJson(Map<String, dynamic> json) {
    if (json['authors'] != null) {
      authors = <Authors>[];
      json['authors'].forEach((v) {
        authors!.add(Authors.fromJson(v));
      });
    }
    responseStatus = json['responseStatus'];
    validationMessage = json['validationMessage'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (authors != null) {
      data['authors'] = authors!.map((v) => v.toJson()).toList();
    }
    data['responseStatus'] = responseStatus;
    data['validationMessage'] = validationMessage;
    data['statusCode'] = statusCode;
    return data;
  }
}

class Authors {
  UserModelClass? userEntity;
  int? followers;
  int? events;

  Authors({this.userEntity, this.followers, this.events});

  Authors.fromJson(Map<String, dynamic> json) {
    userEntity = json['userEntity'] != null
        ? UserModelClass.fromJson(json['userEntity'])
        : null;
    followers = json['followers'];
    events = json['events'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userEntity != null) {
      data['userEntity'] = userEntity!.toJson();
    }
    data['followers'] = followers;
    data['events'] = events;
    return data;
  }
}
