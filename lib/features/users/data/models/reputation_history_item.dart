class ReputationHistoryItem {
  ReputationHistoryItem({
    this.reputationHistoryType,
    this.reputationChange,
    this.creationDate,
    this.postId,
  });

  ReputationHistoryItem.fromJson(dynamic json) {
    reputationHistoryType = json['reputation_history_type'];
    reputationChange = json['reputation_change'];
    creationDate = json['creation_date'];
    postId = json['post_id'];
  }

  String? reputationHistoryType;
  num? reputationChange;
  num? creationDate;
  num? postId;

  ReputationHistoryItem copyWith({
    String? reputationHistoryType,
    num? reputationChange,
    num? creationDate,
    num? postId,
  }) =>
      ReputationHistoryItem(
        reputationHistoryType:
            reputationHistoryType ?? this.reputationHistoryType,
        reputationChange: reputationChange ?? this.reputationChange,
        creationDate: creationDate ?? this.creationDate,
        postId: postId ?? this.postId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reputation_history_type'] = reputationHistoryType;
    map['reputation_change'] = reputationChange;
    map['creation_date'] = creationDate;
    map['post_id'] = postId;
    return map;
  }
}

