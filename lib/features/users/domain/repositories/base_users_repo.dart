import 'package:sof/features/users/presentation/bloc/users_bloc.dart';

abstract class BaseUsersRepo {
  Future<UsersState> getUsers([int pageNumber = 1]);
  Future<UsersState> getReputationHistory(num userId, {int pageNumber = 1});
  
  // Bookmark hooks - no state management, just persistence
  Future<bool> addBookmark(String userId);
  Future<bool> removeBookmark(String userId);
  Future<List<String>> getBookmarkedUserIds();
  Future<bool> isBookmarked(String userId);
}

