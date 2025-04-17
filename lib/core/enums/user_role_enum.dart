enum UserRoleEnum {
  Host('Host'),
  CoHost('CoHost'),
  Guest('Guest'),
  PublicUser('PublicUser');

  const UserRoleEnum(this.type);
  final String type;
}

extension ConvertUserRoleEnum on String {
  UserRoleEnum toUserRoleEnum() {
    switch (this) {
      case 'CoHost':
        return UserRoleEnum.CoHost;
      case 'Host':
        return UserRoleEnum.Host;
      case 'Guest':
        return UserRoleEnum.Guest;
      case 'PublicUser':
        return UserRoleEnum.PublicUser;
      default:
        return UserRoleEnum.Host;
    }
  }
}

enum ContributorType {
  none, // Default case
  public, // Maps to 1
  private, // Maps to 2
  guest, // Maps to 3
}

extension ContributorTypeExtension on ContributorType {
  static ContributorType fromInt(int? value) {
    switch (value) {
      case 1:
        return ContributorType.public;
      case 2:
        return ContributorType.private;
      case 3:
        return ContributorType.guest;
      default:
        return ContributorType.none;
    }
  }
}

enum FollowType {
  none, // Default case
  follower, // Maps to 1
  following, // Maps to 2    // Maps to 3
}

extension FollowTypeExtension on FollowType {
  static FollowType fromInt(int? value) {
    switch (value) {
      case 1:
        return FollowType.follower;
      case 2:
        return FollowType.following;
      default:
        return FollowType.none;
    }
  }
}

enum FollowButtonType { follow, unfollow, remove, none }

FollowButtonType getFollowButtonType(num? followStatus) {
  switch (followStatus) {
    case 0:
    case 3:
    case 4:
      return FollowButtonType.follow;
    case 1:
      return FollowButtonType.remove;
    case 2:
      return FollowButtonType.unfollow;
    default:
      return FollowButtonType.none;
  }
}

enum EmailTemplateTypeEnum {
  eventReminder('EventReminder'),
  eventThankYou('EventThankYou'),
  guestInvite('GuestInvite');

  const EmailTemplateTypeEnum(this.type);

  final String type;
}

extension ConvertEmailTemplateType on String {
  EmailTemplateTypeEnum toEmailTemplateEnum() {
    switch (this) {
      case 'EventReminder':
        return EmailTemplateTypeEnum.eventReminder;
      case 'EventThankYou':
        return EmailTemplateTypeEnum.eventThankYou;
      case 'GuestInvite':
        return EmailTemplateTypeEnum.guestInvite;
      default:
        return EmailTemplateTypeEnum.eventReminder; // fallback
    }
  }
}
