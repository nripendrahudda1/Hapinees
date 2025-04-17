class ModelTimelineCategory {
  List<TimelineCatogoryGroupsModel>? catogoryGroups;
  bool? responseStatus;
  String? validationMessage;

  ModelTimelineCategory(
      {this.catogoryGroups, this.responseStatus, this.validationMessage});

  ModelTimelineCategory.fromJson(Map<String, dynamic> json) {
    if (json['catogoryGroups'] != null) {
      catogoryGroups = <TimelineCatogoryGroupsModel>[];
      json['catogoryGroups'].forEach((v) {
        catogoryGroups!.add(TimelineCatogoryGroupsModel.fromJson(v));
      });
    }
    responseStatus = json['responseStatus'];
    validationMessage = json['validationMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (catogoryGroups != null) {
      data['catogoryGroups'] = catogoryGroups!.map((v) => v.toJson()).toList();
    }
    data['responseStatus'] = responseStatus;
    data['validationMessage'] = validationMessage;
    return data;
  }
}

class TimelineCatogoryGroupsModel {
  int? categoryGroupId;
  String? categoryGroupName;
  String? categoryGroupIconUrl;
  int? createdBy;
  String? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;

  TimelineCatogoryGroupsModel(
      {this.categoryGroupId,
      this.categoryGroupName,
      this.categoryGroupIconUrl,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn});

  TimelineCatogoryGroupsModel.fromJson(Map<String, dynamic> json) {
    categoryGroupId = json['categoryGroupId'];
    categoryGroupName = json['categoryGroupName'];
    categoryGroupIconUrl = json['categoryGroupIconUrl'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryGroupId'] = categoryGroupId;
    data['categoryGroupName'] = categoryGroupName;
    data['categoryGroupIconUrl'] = categoryGroupIconUrl;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['modifiedBy'] = modifiedBy;
    data['modifiedOn'] = modifiedOn;
    return data;
  }
}
