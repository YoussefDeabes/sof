class UserWrapper {
  UserWrapper({
    this.userId,
    this.displayName,
    this.reputation,
    this.profileImage,
    this.link,
    this.accountId,
  });

  UserWrapper.fromJson(dynamic json) {
    userId = json['user_id'];
    displayName = json['display_name'];
    reputation = json['reputation'];
    profileImage = json['profile_image'];
    link = json['link'];
    accountId = json['account_id'];
  }

  num? userId;
  String? displayName;
  num? reputation;
  String? profileImage;
  String? link;
  num? accountId;

  UserWrapper copyWith({
    num? userId,
    String? displayName,
    num? reputation,
    String? profileImage,
    String? link,
    num? accountId,
  }) => UserWrapper(
    userId: userId ?? this.userId,
    displayName: displayName ?? this.displayName,
    reputation: reputation ?? this.reputation,
    profileImage: profileImage ?? this.profileImage,
    link: link ?? this.link,
    accountId: accountId ?? this.accountId,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['display_name'] = displayName;
    map['reputation'] = reputation;
    map['profile_image'] = profileImage;
    map['link'] = link;
    map['account_id'] = accountId;
    return map;
  }
}
