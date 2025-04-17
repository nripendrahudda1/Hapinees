enum ProfilePickStatus {
  coverImage,
  profileImage,
}

enum LoginSourceType { google, facebook, apple }

extension LoginSourceTypeExtension on LoginSourceType {
  String get stringValue {
    switch (this) {
      case LoginSourceType.google:
        return 'google';
      case LoginSourceType.facebook:
        return 'facebook';
      case LoginSourceType.apple:
        return 'apple';
    }
  }
}
