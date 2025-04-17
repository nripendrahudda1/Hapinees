import 'dart:convert';
// class EventCategoryCollection {
//   List<EventCategoryMasterList>? eventGroupMasterList;
//   bool? responseStatus;
//   String? validationMessage;
//   int? statusCode;

//   EventCategoryCollection(
//       {this.eventGroupMasterList,
//       this.responseStatus,
//       this.validationMessage,
//       this.statusCode});

//   EventCategoryCollection.fromJson(Map<String, dynamic> json) {
//     print("eventCategoryMasterList ************** $json");
//     if (json['eventGroupMasterList'] != null) {
//       eventGroupMasterList = <EventCategoryMasterList>[];
//       json['eventGroupMasterList'].forEach((v) {
//         eventGroupMasterList!.add(EventCategoryMasterList.fromJson(v));
//       });
//     }
//     responseStatus = json['responseStatus'];
//     validationMessage = json['validationMessage'];
//     statusCode = json['statusCode'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (eventGroupMasterList != null) {
//       data['eventGroupMasterList'] =
//           eventGroupMasterList!.map((v) => v.toJson()).toList();
//     }
//     data['responseStatus'] = responseStatus;
//     data['validationMessage'] = validationMessage;
//     data['statusCode'] = statusCode;
//     return data;
//   }
// }

// class EventCategoryMasterList {
//   int? eventTypeMasterId;
//   String? eventGroupName;
//   String? icon;
//   String? eventCategoryCode;
//   String? apiEndPoint;
//   String? language;
//   bool? isActive;
//   int? createdBy;
//   String? createdOn;
//   int? modifiedBy;
//   String? modifiedOn;

//   EventCategoryMasterList(
//       {this.eventTypeMasterId,
//       this.eventGroupName,
//       this.icon,
//       this.eventCategoryCode,
//       this.apiEndPoint,
//       this.language,
//       this.isActive,
//       this.createdBy,
//       this.createdOn,
//       this.modifiedBy,
//       this.modifiedOn});

//   EventCategoryMasterList.fromJson(Map<String, dynamic> json) {
//     eventTypeMasterId = json['eventTypeMasterId'];
//     eventGroupName = json['eventGroupName'];
//     icon = json['icon'];
//     eventCategoryCode = json['eventCategoryCode'];
//     apiEndPoint = json['apiEndPoint'];
//     language = json['language'];
//     isActive = json['isActive'];
//     createdBy = json['createdBy'];
//     createdOn = json['createdOn'];
//     modifiedBy = json['modifiedBy'];
//     modifiedOn = json['modifiedOn'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['eventTypeMasterId'] = eventTypeMasterId;
//     data['eventGroupName'] = eventGroupName;
//     data['icon'] = icon;
//     data['eventCategoryCode'] = eventCategoryCode;
//     data['apiEndPoint'] = apiEndPoint;
//     data['language'] = language;
//     data['isActive'] = isActive;
//     data['createdBy'] = createdBy;
//     data['createdOn'] = createdOn;
//     data['modifiedBy'] = modifiedBy;
//     data['modifiedOn'] = modifiedOn;
//     return data;
//   }
// }

EventCategoryCollection eventCategoryCollectionFromJson(String str) => EventCategoryCollection.fromJson(json.decode(str));

String eventCategoryCollectionToJson(EventCategoryCollection data) => json.encode(data.toJson());

class EventCategoryCollection {
    final List<Module>? modules;
    final List<String>? eventFilters;
    final bool? responseStatus;
    final String? validationMessage;
    final int? statusCode;

    EventCategoryCollection({
        this.modules,
        this.eventFilters,
        this.responseStatus,
        this.validationMessage,
        this.statusCode,
    });

    factory EventCategoryCollection.fromJson(Map<String, dynamic> json) => EventCategoryCollection(
        modules: json["modules"] == null ? [] : List<Module>.from(json["modules"]!.map((x) => Module.fromJson(x))),
        eventFilters: json["eventFilters"] == null ? [] : List<String>.from(json["eventFilters"]!.map((x) => x)),
        responseStatus: json["responseStatus"],
        validationMessage: json["validationMessage"],
        statusCode: json["statusCode"],
    );

    Map<String, dynamic> toJson() => {
        "modules": modules == null ? [] : List<dynamic>.from(modules!.map((x) => x.toJson())),
        "eventFilters": eventFilters == null ? [] : List<dynamic>.from(eventFilters!.map((x) => x)),
        "responseStatus": responseStatus,
        "validationMessage": validationMessage,
        "statusCode": statusCode,
    };
}

class Module {
    final int? moduleId;
    final String? moduleName;
    final String? eventIconSelected;
    final String? eventIconUnselected;

    Module({
        this.moduleId,
        this.moduleName,
        this.eventIconSelected,
        this.eventIconUnselected,
    });

    factory Module.fromJson(Map<String, dynamic> json) => Module(
        moduleId: json["moduleId"],
        moduleName: json["moduleName"],
        eventIconSelected: json["eventIconSelected"],
        eventIconUnselected: json["eventIconUnselected"],
    );

    Map<String, dynamic> toJson() => {
        "moduleId": moduleId,
        "moduleName": moduleName,
        "eventIconSelected": eventIconSelected,
        "eventIconUnselected": eventIconUnselected,
    };
}
