class PersonalEventThemeModel {
  List<PersonalEventThemeMasterList>? personalEventThemeMasterList;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventThemeModel(
      {this.personalEventThemeMasterList,
        this.responseStatus,
        this.validationMessage,
        this.statusCode});

  PersonalEventThemeModel.fromJson(Map<String, dynamic> json) {
    if (json['personalEventThemeMasterList'] != null) {
      personalEventThemeMasterList = <PersonalEventThemeMasterList>[];
      json['personalEventThemeMasterList'].forEach((v) {
        personalEventThemeMasterList!
            .add(new PersonalEventThemeMasterList.fromJson(v));
      });
    }
    responseStatus = json['responseStatus'];
    validationMessage = json['validationMessage'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.personalEventThemeMasterList != null) {
      data['personalEventThemeMasterList'] =
          this.personalEventThemeMasterList!.map((v) => v.toJson()).toList();
    }
    data['responseStatus'] = this.responseStatus;
    data['validationMessage'] = this.validationMessage;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class PersonalEventThemeMasterList {
  bool? hasActivities;
  int? personalEventThemeId;
  String? personalEventThemeName;
  String? defaultImageUrl;
  String? language;
  bool? isActive;
  int? createdBy;
  String? createdOn;
  Null? modifiedBy;
  Null? modifiedOn;

  PersonalEventThemeMasterList(
      {this.hasActivities,
        this.personalEventThemeId,
        this.personalEventThemeName,
        this.defaultImageUrl,
        this.language,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn});

  PersonalEventThemeMasterList.fromJson(Map<String, dynamic> json) {
    hasActivities = json['hasActivities'];
    personalEventThemeId = json['personalEventThemeId'];
    personalEventThemeName = json['personalEventThemeName'];
    defaultImageUrl = json['defaultImageUrl'];
    language = json['language'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasActivities'] = this.hasActivities;
    data['personalEventThemeId'] = this.personalEventThemeId;
    data['personalEventThemeName'] = this.personalEventThemeName;
    data['defaultImageUrl'] = this.defaultImageUrl;
    data['language'] = this.language;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    return data;
  }
}