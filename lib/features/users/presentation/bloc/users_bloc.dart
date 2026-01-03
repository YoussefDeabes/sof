import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sof/features/users/data/models/reputation_history_list_wrapper.dart';
import 'package:sof/features/users/data/models/users_list_wrapper.dart';
import 'package:sof/features/users/data/models/user_wrapper.dart';
import 'package:sof/features/users/data/repositories/users_repo.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final usersRepo = UsersRepo();
  List<UserWrapper> allUsers = [];
  List<String> bookmarkedUserIds = [];
  bool showBookmarkedOnly = false;
  int currentPage = 1;
  bool hasReachedEnd = false;
  bool _isLoadingMore = false;

  UsersBloc() : super(UsersInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<LoadReputationHistoryEvent>(_onLoadReputationHistory);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
    on<FilterBookmarkedEvent>(_onFilterBookmarked);
    on<RefreshBookmarksEvent>(_onRefreshBookmarks);
  }

  Future<void> _onLoadUsers(LoadUsersEvent event, Emitter emit) async {
    if (hasReachedEnd && event.isLoadMore == true) return;

    // Prevent multiple simultaneous load more requests
    if (event.isLoadMore == true && _isLoadingMore) return;

    if (event.isLoadMore == false) {
      emit(UsersLoadingState());
    } else {
      _isLoadingMore = true;
    }

    final result = await usersRepo.getUsers(event.pageNumber);

    if (result is UsersListSuccessState) {
      final fetched = result.wrapper.items ?? [];
      final hasMore = result.wrapper.hasMore ?? false;

      // Check if we've reached the end (fetched less than page size or no more)
      if (fetched.length < 20 || !hasMore) {
        hasReachedEnd = true;
      }

      if (event.isLoadMore == true) {
        allUsers.addAll(fetched);
      } else {
        allUsers = fetched;
        hasReachedEnd = false; // Reset when loading fresh
      }

      currentPage = event.pageNumber;
      await _syncBookmarks();
      _applyFilter(emit);
    } else if (result is NetworkError) {
      emit(result);
    } else if (result is ErrorState) {
      emit(result);
    } else {
      emit(ErrorState("Unknown error occurred"));
    }

    // Reset loading flag after request completes
    if (event.isLoadMore == true) {
      _isLoadingMore = false;
    }
  }

  void loadNextPage() {
    // Prevent multiple calls: check if already loading or reached end
    if (hasReachedEnd || _isLoadingMore) return;

    add(LoadUsersEvent(pageNumber: currentPage + 1, isLoadMore: true));
  }

  Future<void> _onLoadReputationHistory(
    LoadReputationHistoryEvent event,
    Emitter emit,
  ) async {
    emit(ReputationHistoryLoadingState());
    final result = await usersRepo.getReputationHistory(
      event.userId,
      pageNumber: event.pageNumber,
    );

    if (result is ReputationHistorySuccessState) {
      emit(result);
    } else if (result is NetworkError) {
      emit(result);
    } else if (result is ErrorState) {
      emit(result);
    } else {
      emit(ErrorState("Unknown error occurred"));
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkEvent event,
    Emitter emit,
  ) async {
    final userId = event.userId.toString();
    final isBookmarked = await usersRepo.isBookmarked(userId);

    if (isBookmarked) {
      await usersRepo.removeBookmark(userId);
    } else {
      await usersRepo.addBookmark(userId);
    }

    await _syncBookmarks();
    _applyFilter(emit);
  }

  void _onFilterBookmarked(FilterBookmarkedEvent event, Emitter emit) {
    showBookmarkedOnly = event.showBookmarkedOnly;
    // Reset pagination when filtering (only affects "all users" mode)
    if (!showBookmarkedOnly) {
      // If switching back to all users, reset pagination
      currentPage = 1;
      hasReachedEnd = false;
    }
    _applyFilter(emit);
  }

  Future<void> _onRefreshBookmarks(
    RefreshBookmarksEvent event,
    Emitter emit,
  ) async {
    await _syncBookmarks();
    _applyFilter(emit);
  }

  Future<void> _syncBookmarks() async {
    bookmarkedUserIds = await usersRepo.getBookmarkedUserIds();
  }

  void _applyFilter(Emitter emit) {
    if (showBookmarkedOnly) {
      final filtered = allUsers
          .where(
            (user) => bookmarkedUserIds.contains(user.userId?.toString() ?? ''),
          )
          .toList();
      emit(
        UsersListLoadedState(filtered, true),
      ); // Always reached end for filtered
    } else {
      emit(UsersListLoadedState(allUsers, hasReachedEnd));
    }
  }
}
