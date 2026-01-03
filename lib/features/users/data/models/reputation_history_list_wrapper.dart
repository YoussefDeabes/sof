import 'package:sof/features/users/data/models/reputation_history_item.dart';

class ReputationHistoryListWrapper {
  ReputationHistoryListWrapper({
    this.items,
    this.hasMore,
    this.quotaMax,
    this.quotaRemaining,
  });

  ReputationHistoryListWrapper.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(ReputationHistoryItem.fromJson(v));
      });
    }
    hasMore = json['has_more'];
    quotaMax = json['quota_max'];
    quotaRemaining = json['quota_remaining'];
  }

  List<ReputationHistoryItem>? items;
  bool? hasMore;
  num? quotaMax;
  num? quotaRemaining;

  ReputationHistoryListWrapper copyWith({
    List<ReputationHistoryItem>? items,
    bool? hasMore,
    num? quotaMax,
    num? quotaRemaining,
  }) =>
      ReputationHistoryListWrapper(
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

