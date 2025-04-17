
import 'dart:convert';

EmailTemplate emailTemplateFromJson(String str) => EmailTemplate.fromJson(json.decode(str));

String emailTemplateToJson(EmailTemplate data) => json.encode(data.toJson());
class EmailTemplate {
    final EmailTemplateClass? emailTemplate;
    final bool? responseStatus;
    final String? validationMessage;
    final int? statusCode;
    EmailTemplate({
        this.emailTemplate,
        this.responseStatus,
        this.validationMessage,
        this.statusCode,
    });

    factory EmailTemplate.fromJson(Map<String, dynamic> json) => EmailTemplate(
        emailTemplate: json["emailTemplate"] == null ? null : EmailTemplateClass.fromJson(json["emailTemplate"]),
        responseStatus: json["responseStatus"],
        validationMessage: json["validationMessage"],
        statusCode: json["statusCode"],
    );

    Map<String, dynamic> toJson() => {
        "emailTemplate": emailTemplate?.toJson(),
        "responseStatus": responseStatus,
        "validationMessage": validationMessage,
        "statusCode": statusCode,
    };
}

class EmailTemplateClass {
    final int? templateId;
    final String? emailSubject;
    final String? emailBody;
    final int? eventTypeId;
    final dynamic lastSentOn;

    EmailTemplateClass({
        this.templateId,
        this.emailSubject,
        this.emailBody,
        this.eventTypeId,
        this.lastSentOn,
    });

    factory EmailTemplateClass.fromJson(Map<String, dynamic> json) => EmailTemplateClass(
        templateId: json["templateId"],
        emailSubject: json["emailSubject"],
        emailBody: json["emailBody"],
        eventTypeId: json["eventTypeId"],
        lastSentOn: json["lastSentOn"],
    );

    Map<String, dynamic> toJson() => {
        "templateId": templateId,
        "emailSubject": emailSubject,
        "emailBody": emailBody,
        "eventTypeId": eventTypeId,
        "lastSentOn": lastSentOn,
    };
}

