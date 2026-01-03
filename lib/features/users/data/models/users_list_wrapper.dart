import 'package:sof/features/users/data/models/user_wrapper.dart';

class UsersListWrapper {
  UsersListWrapper({
    this.items,
    this.hasMore,
    this.quotaMax,
    this.quotaRemaining,
  });

  UsersListWrapper.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(UserWrapper.fromJson(v));
      });
    }
    hasMore = json['has_more'];
    quotaMax = json['quota_max'];
    quotaRemaining = json['quota_remaining'];
  }

  List<UserWrapper>? items;
  bool? hasMore;
  num? quotaMax;
  num? quotaRemaining;

  UsersListWrapper copyWith({
    List<UserWrapper>? items,
    bool? hasMore,
    num? quotaMax,
    num? quotaRemaining,
  }) =>
      UsersListWrapper(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        quotaMax: quotaMax ?? this.quotaMax,
        quotaRemaining: quotaRemaining ?? this.quotaRemaining,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    map['has_more'] = hasMore;
    map['quota_max'] = quotaMax;
    map['quota_remaining'] = quotaRemaining;
    return map;
  }
}

