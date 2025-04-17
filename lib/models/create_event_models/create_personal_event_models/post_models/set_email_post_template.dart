// To parse this JSON data, do
//
//     final sendPostEmailTemplateModel = sendPostEmailTemplateModelFromJson(jsonString);

import 'dart:convert';

SendPostEmailTemplateModel sendPostEmailTemplateModelFromJson(String str) => SendPostEmailTemplateModel.fromJson(json.decode(str));
String sendPostEmailTemplateModelToJson(SendPostEmailTemplateModel data) => json.encode(data.toJson());
class SendPostEmailTemplateModel {
    final int? templateId;
    final int? eventId;
    final String? fromEmail;
    final String? emailSubject;
    final String? emailBody;

    SendPostEmailTemplateModel({
        this.templateId,
        this.eventId,
        this.fromEmail,
        this.emailSubject,
        this.emailBody,
    });

    factory SendPostEmailTemplateModel.fromJson(Map<String, dynamic> json) => SendPostEmailTemplateModel(
        templateId: json["templateId"],
        eventId: json["eventId"],
        fromEmail: json["fromEmail"],
        emailSubject: json["emailSubject"],
        emailBody: json["emailBody"],
    );

    Map<String, dynamic> toJson() => {
        "templateId": templateId,
        "eventId": eventId,
        "fromEmail": fromEmail,
        "emailSubject": emailSubject,
        "emailBody": emailBody,
    };
}
