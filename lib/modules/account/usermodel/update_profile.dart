
import 'dart:convert';

UpdateProfile updateProfileFromJson(String str) => UpdateProfile.fromJson(json.decode(str));

class UpdateProfile {
    final String? imageUrl;
    final bool? responseStatus;
    final dynamic validationMessage;

    UpdateProfile({
        this.imageUrl,
        this.responseStatus,
        this.validationMessage,
    });

    factory UpdateProfile.fromJson(Map<String, dynamic> json) => UpdateProfile(
        imageUrl: json["ImageUrl"],
        responseStatus: json["ResponseStatus"],
        validationMessage: json["ValidationMessage"],
    );

}
