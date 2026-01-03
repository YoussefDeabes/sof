part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class LoadUsersEvent extends UsersEvent {
  final int pageNumber;
  final bool isLoadMore;

  LoadUsersEvent({
    this.pageNumber = 1,
    this.isLoadMore = false,
  });
}

class LoadReputationHistoryEvent extends UsersEvent {
  final num userId;
  final int pageNumber;

  LoadReputationHistoryEvent(this.userId, {this.pageNumber = 1});
}

class ToggleBookmarkEvent extends UsersEvent {
  final num userId;

  ToggleBookmarkEvent(this.userId);
}

class FilterBookmarkedEvent extends UsersEvent {
  final bool showBookmarkedOnly;

  FilterBookmarkedEvent(this.showBookmarkedOnly);
}

class RefreshBookmarksEvent extends UsersEvent {}

