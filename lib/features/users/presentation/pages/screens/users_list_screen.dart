import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sof/core/res/const_text_styles.dart';
import 'package:sof/core/util/bloc/theme/theme_cubit.dart';
import 'package:sof/core/util/helpers/route_manager.dart';
import 'package:sof/core/util/lang/app_localization_keys.dart';
import 'package:sof/core/util/ui/feedback_controller.dart';
import 'package:sof/core/widgets/base_screen_widget.dart';
import 'package:sof/core/widgets/base_stateful_widget.dart';
import 'package:sof/features/common/choose_language_widget.dart';
import 'package:sof/features/common/text_widget.dart';
import 'package:sof/features/users/data/repositories/users_repo.dart';
import 'package:sof/features/users/presentation/bloc/users_bloc.dart';
import 'package:sof/features/users/presentation/pages/screens/user_details_screen.dart';
import 'package:sof/features/users/data/models/user_wrapper.dart';
import 'package:sof/features/users/presentation/pages/widgets/user_item_shimmer.dart';
import 'package:sof/features/users/presentation/pages/widgets/user_item_widget.dart';

class UsersListScreen extends BaseScreenWidget {
  const UsersListScreen({super.key});

  @override
  BaseState<UsersListScreen> screenCreateState() => _UsersListScreenState();
}

class _UsersListScreenState extends BaseScreenState<UsersListScreen> {
  UsersBloc get usersBloc => BlocProvider.of<UsersBloc>(context);
  final UsersRepo _usersRepo = UsersRepo();
  final ScrollController _scrollController = ScrollController();
  bool _showBookmarkedOnly = false;
  Map<String, bool> _bookmarkCache = {};

  @override
  void initState() {
    super.initState();
    usersBloc.add(LoadUsersEvent(pageNumber: 1));
    _loadBookmarks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    final bookmarkedIds = await _usersRepo.getBookmarkedUserIds();
    _bookmarkCache = {for (var id in bookmarkedIds) id: true};
    if (mounted) setState(() {});
  }

  bool _isBookmarked(String userId) {
    return _bookmarkCache[userId] ?? false;
  }

  Widget _buildUsersList(List<UserWrapper> users, bool hasReachedEnd) {
    if (users.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          if (_showBookmarkedOnly) {
            // Refresh bookmarks from local storage only
            usersBloc.add(RefreshBookmarksEvent());
          } else {
            // Refresh users from API
            usersBloc.add(LoadUsersEvent(pageNumber: 1));
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: TextWidget(
                text: _showBookmarkedOnly
                    ? translate(LangKeys.noBookmarkedUsers)
                    : translate(LangKeys.noUsersFound),
                textStyle: getRegularStyle(),
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        usersBloc.add(LoadUsersEvent(pageNumber: 1));
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Only trigger on scroll end to prevent multiple calls
          if (notification is ScrollEndNotification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              if (!usersBloc.hasReachedEnd) {
                usersBloc.loadNextPage();
              }
            }
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(16.w),
          itemCount: users.length + (hasReachedEnd ? 0 : 1),
          itemBuilder: (context, index) {
            if (index >= users.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const UserItemShimmer(),
              );
            }

            final user = users[index];
            final userIdString = user.userId?.toString() ?? '';
            final isBookmarked = _isBookmarked(userIdString);
            return UserItemWidget(
              user: user,
              onTap: () {
                if (user.userId != null) {
                  RouteManager.navigateTo(
                    UserDetailsScreen(userId: user.userId!,name: user.displayName ?? ""),
                  );
                }
              },
              onBookmarkTap: () {
                if (user.userId != null) {
                  usersBloc.add(ToggleBookmarkEvent(user.userId!));
                  setState(() {
                    _bookmarkCache[userIdString] = !isBookmarked;
                  });
                }
              },
              isBookmarked: isBookmarked,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: false,
        title: TextWidget(
          text: translate(LangKeys.stackOverflowUsers),
          textStyle: getSemiBoldStyle(fontSize: FontSize.subTitle),
        ),
        actions: [
          // Language switcher
          ChooseLanguageWidget(),
          // Theme toggle
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  context.read<ThemeCubit>().toggle();
                },
                tooltip: translate(LangKeys.darkMode),
              );
            },
          ),
          // Bookmark filter
          IconButton(
            icon: Icon(
              _showBookmarkedOnly ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () {
              setState(() {
                _showBookmarkedOnly = !_showBookmarkedOnly;
              });
              usersBloc.add(FilterBookmarkedEvent(_showBookmarkedOnly));
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(0);
              }
            },
            tooltip: _showBookmarkedOnly
                ? translate(LangKeys.showAll)
                : translate(LangKeys.showBookmarked),
          ),
        ],
      ),
      body: BlocConsumer<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is NetworkError) {
            showToast(state.message);
          } else if (state is ErrorState) {
            showToast(state.message);
          } else if (state is UsersListLoadedState) {
            _loadBookmarks();
          }
        },
        builder: (context, state) {
          // Handle error states first (override cached data)
          if (state is NetworkError || state is ErrorState) {
            // If we have cached data, show it despite the error
            // Error is already shown via toast in listener
            if (usersBloc.allUsers.isNotEmpty) {
              return _buildCachedUsersList();
            }
            // If no cached data, show empty state
            return _buildEmptyState();
          }

          // Handle initial loading
          if (state is UsersLoadingState && usersBloc.allUsers.isEmpty) {
            return _buildShimmerLoading();
          }

          // Handle UsersListLoadedState
          if (state is UsersListLoadedState) {
            return _buildUsersList(state.users, state.hasReachedEnd);
          }

          // Render cached users list whenever data exists
          if (usersBloc.allUsers.isNotEmpty) {
            return _buildCachedUsersList();
          }

          // Fallback empty state
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(5, (index) => const UserItemShimmer()),
      ),
    );
  }

  Widget _buildCachedUsersList() {
    // Apply filter to existing data
    List<UserWrapper> displayedUsers = [];
    if (_showBookmarkedOnly) {
      displayedUsers = usersBloc.allUsers
          .where(
            (user) => _bookmarkCache.containsKey(user.userId?.toString() ?? ''),
          )
          .toList();
      return _buildUsersList(displayedUsers, true);
    } else {
      return _buildUsersList(usersBloc.allUsers, usersBloc.hasReachedEnd);
    }
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () async {
        usersBloc.add(LoadUsersEvent(pageNumber: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: TextWidget(
              text: translate(LangKeys.noDataAvailable),
              textStyle: getRegularStyle(),
            ),
          ),
        ),
      ),
    );
  }
}
