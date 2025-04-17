class NotificationModel {
  List<Notifications>? notifications;

  NotificationModel({this.notifications});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? notificationId;
  int? notificationTypeId;
  String? notificationTypeCode;
  String? notificationTypeDescription;
  String? notificationText;
  String? actionType;
  String? additionalParams;
  String? createdDate;
  String? imageUrl;
  bool? isRead;

  Notifications(
      {this.notificationId,
      this.notificationTypeId,
      this.notificationTypeCode,
      this.notificationTypeDescription,
      this.notificationText,
      this.actionType,
      this.additionalParams,
      this.createdDate,
      this.imageUrl,
      this.isRead});

  Notifications.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    notificationTypeId = json['notificationTypeId'];
    notificationTypeCode = json['notificationTypeCode'];
    notificationTypeDescription = json['notificationTypeDescription'];
    notificationText = json['notificationText'];
    actionType = json['actionType'];
    additionalParams = json['additionalParams'];
    createdDate = json['createdDate'];
    imageUrl = json['imageUrl'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['notificationTypeId'] = notificationTypeId;
    data['notificationTypeCode'] = notificationTypeCode;
    data['notificationTypeDescription'] = notificationTypeDescription;
    data['notificationText'] = notificationText;
    data['actionType'] = actionType;
    data['additionalParams'] = additionalParams;
    data['createdDate'] = createdDate;
    data['imageUrl'] = imageUrl;
    data['isRead'] = isRead;
    return data;
  }
}
