import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sof/core/res/const_text_styles.dart';
import 'package:sof/core/util/lang/app_localization_keys.dart';
import 'package:sof/core/util/ui/feedback_controller.dart';
import 'package:sof/core/widgets/base_screen_widget.dart';
import 'package:sof/core/widgets/base_stateful_widget.dart';
import 'package:sof/features/common/text_widget.dart';
import 'package:sof/features/users/presentation/bloc/users_bloc.dart';
import 'package:sof/features/users/presentation/pages/widgets/reputation_history_item_widget.dart';
import 'package:sof/features/users/presentation/pages/widgets/reputation_history_shimmer.dart';

class UserDetailsScreen extends BaseScreenWidget {
  final num userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  BaseState<UserDetailsScreen> screenCreateState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends BaseScreenState<UserDetailsScreen> {
  UsersBloc get usersBloc => BlocProvider.of<UsersBloc>(context);

  @override
  void initState() {
    super.initState();
    usersBloc.add(LoadReputationHistoryEvent(widget.userId));
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
          text: translate(LangKeys.reputationHistory),
          textStyle: getSemiBoldStyle(fontSize: FontSize.subTitle),
        ),
      ),
      body: BlocConsumer<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is NetworkError) {
            showToast(state.message);
          } else if (state is ErrorState) {
            showToast(state.message);
          }
        },
        builder: (context, state) {
          if (state is ReputationHistoryLoadingState) {
            return _buildShimmerLoading();
          }

          if (state is ReputationHistorySuccessState) {
            final items = state.wrapper.items ?? [];
            if (items.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  usersBloc.add(LoadReputationHistoryEvent(widget.userId));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: TextWidget(
                        text: translate(LangKeys.noReputationHistory),
                        textStyle: getRegularStyle(),
                      ),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                usersBloc.add(LoadReputationHistoryEvent(widget.userId));
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ReputationHistoryItemWidget(
                    item: items[index],
                  );
                },
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              usersBloc.add(LoadReputationHistoryEvent(widget.userId));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: TextWidget(
                    text: translate(LangKeys.failedToLoadUserDetails),
                    textStyle: getRegularStyle(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(5, (index) => const ReputationHistoryShimmer()),
      ),
    );
  }
}
