import 'package:sof/core/network/errors/error_messages.dart';
import 'package:sof/core/network/errors/network_exceptions.dart';
import 'package:sof/core/prefs/pref_manager.dart';
import 'package:sof/features/users/data/datasources/users_api_manager.dart';
import 'package:sof/features/users/data/models/reputation_history_list_wrapper.dart';
import 'package:sof/features/users/data/models/users_list_wrapper.dart';
import 'package:sof/features/users/domain/repositories/base_users_repo.dart';
import 'package:sof/features/users/presentation/bloc/users_bloc.dart';

class UsersRepo extends BaseUsersRepo {
  @override
  Future<UsersState> getUsers([int pageNumber = 1]) async {
    UsersState? usersState;
    final lang = 'en'; // Default language
    try {
      await UsersApiManager.getUsers(
        pageNumber,
        (UsersListWrapper wrapper) {
          usersState = UsersListSuccessState(wrapper);
        },
        (NetworkExceptions details) {
          usersState = NetworkError(
            ErrorMessages.getMessage(details.errorMsg ?? "", lang),
          );
        },
      );
    } catch (error) {
      usersState = ErrorState(error.toString());
    }
    return usersState!;
  }

  @override
  Future<UsersState> getReputationHistory(num userId, {int pageNumber = 1}) async {
    UsersState? usersState;
    final lang = 'en'; // Default language - will be dynamic with localization
    try {
      await UsersApiManager.getReputationHistory(
        userId,
        pageNumber,
        (ReputationHistoryListWrapper wrapper) {
          usersState = ReputationHistorySuccessState(wrapper);
        },
        (NetworkExceptions details) {
          usersState = NetworkError(
            ErrorMessages.getMessage(details.errorMsg ?? "", lang),
          );
        },
      );
    } catch (error) {
      usersState = ErrorState(error.toString());
    }
    return usersState!;
  }

  @override
  Future<bool> addBookmark(String userId) async {
    try {
      final bookmarkedIds = await getBookmarkedUserIds();
      if (!bookmarkedIds.contains(userId)) {
        bookmarkedIds.add(userId);
        await PrefManager.setBookmarkedUsers(bookmarkedIds);
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> removeBookmark(String userId) async {
    try {
      final bookmarkedIds = await getBookmarkedUserIds();
      bookmarkedIds.remove(userId);
      await PrefManager.setBookmarkedUsers(bookmarkedIds);
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<List<String>> getBookmarkedUserIds() async {
    return await PrefManager.getBookmarkedUsers();
  }

  @override
  Future<bool> isBookmarked(String userId) async {
    final bookmarkedIds = await getBookmarkedUserIds();
    return bookmarkedIds.contains(userId);
  }
}

