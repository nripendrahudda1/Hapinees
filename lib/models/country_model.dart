class CountryModel {
  int? id;
  String? countryCode;
  String? countryIsdCode;
  String? countryName;
  String? countryFlagUrl;
  String? countryImageUrl;
  String? emergencyContact;

  CountryModel(
      {this.id,
      this.countryCode,
      this.countryIsdCode,
      this.countryName,
      this.countryFlagUrl,
      this.countryImageUrl,
      this.emergencyContact});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['countryCode'];
    countryIsdCode = json['countryIsdCode'];
    countryName = json['countryName'];
    countryFlagUrl = json['countryFlagUrl'];
    countryImageUrl = json['countryImageUrl'];
    emergencyContact = json['emergencyContact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['countryCode'] = countryCode;
    data['countryIsdCode'] = countryIsdCode;
    data['countryName'] = countryName;
    data['countryFlagUrl'] = countryFlagUrl;
    data['countryImageUrl'] = countryImageUrl;
    data['emergencyContact'] = emergencyContact;
    return data;
  }
}
