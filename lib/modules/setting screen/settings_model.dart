class CompanySettings {
  String? features;
  String? howToUse;
  String? privacyPolicy;
  String? tipsAndFaq;
  String? aboutTravelory;
  String? termsAndCondition;
  int? maxMemoryImagesPerDay;
  String? feature1Text;
  String? feature2Text;
  String? dataPrivacyStatement;
  String? howToUseTitle1;
  String? howToUseDescription1;
  String? howToUseTitle2;
  String? howToUseDescription2;
  int? minDistanceForLocationTracking;
  int? minDurationForLocationTracking;

  CompanySettings(
      {this.features,
      this.howToUse,
      this.privacyPolicy,
      this.tipsAndFaq,
      this.aboutTravelory,
      this.termsAndCondition,
      this.maxMemoryImagesPerDay,
      this.feature1Text,
      this.feature2Text,
      this.dataPrivacyStatement,
      this.howToUseTitle1,
      this.howToUseDescription1,
      this.howToUseTitle2,
      this.howToUseDescription2,
      this.minDistanceForLocationTracking,
      this.minDurationForLocationTracking});

  CompanySettings.fromJson(Map<String, dynamic> json) {
    features = json['features'];
    howToUse = json['howToUse'];
    privacyPolicy = json['privacyPolicy'];
    tipsAndFaq = json['tipsAndFaq'];
    aboutTravelory = json['aboutTravelory'];
    termsAndCondition = json['termsAndCondition'];
    maxMemoryImagesPerDay = json['maxMemoryImagesPerDay'];
    feature1Text = json['feature1Text'];
    feature2Text = json['feature2Text'];
    dataPrivacyStatement = json['dataPrivacyStatement'];
    howToUseTitle1 = json['howToUseTitle1'];
    howToUseDescription1 = json['howToUseDescription1'];
    howToUseTitle2 = json['howToUseTitle2'];
    howToUseDescription2 = json['howToUseDescription2'];
    minDistanceForLocationTracking = json['minDistanceForLocationTracking'];
    minDurationForLocationTracking = json['minDurationForLocationTracking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['features'] = features;
    data['howToUse'] = howToUse;
    data['privacyPolicy'] = privacyPolicy;
    data['tipsAndFaq'] = tipsAndFaq;
    data['aboutTravelory'] = aboutTravelory;
    data['termsAndCondition'] = termsAndCondition;
    data['maxMemoryImagesPerDay'] = maxMemoryImagesPerDay;
    data['feature1Text'] = feature1Text;
    data['feature2Text'] = feature2Text;
    data['dataPrivacyStatement'] = dataPrivacyStatement;
    data['howToUseTitle1'] = howToUseTitle1;
    data['howToUseDescription1'] = howToUseDescription1;
    data['howToUseTitle2'] = howToUseTitle2;
    data['howToUseDescription2'] = howToUseDescription2;
    data['minDistanceForLocationTracking'] = minDistanceForLocationTracking;
    data['minDurationForLocationTracking'] = minDurationForLocationTracking;
    return data;
  }
}
