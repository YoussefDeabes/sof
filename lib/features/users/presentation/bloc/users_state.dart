part of 'users_bloc.dart';

@immutable
sealed class UsersState {
  const UsersState();
}

final class UsersInitial extends UsersState {}

class UsersLoadingState extends UsersState {}

final class UsersListSuccessState extends UsersState {
  final UsersListWrapper wrapper;

  const UsersListSuccessState(this.wrapper);
}

final class UsersListLoadedState extends UsersState {
  final List<UserWrapper> users;
  final bool hasReachedEnd;

  const UsersListLoadedState(this.users, this.hasReachedEnd);
}

class ReputationHistoryLoadingState extends UsersState {}

final class ReputationHistorySuccessState extends UsersState {
  final ReputationHistoryListWrapper wrapper;

  const ReputationHistorySuccessState(this.wrapper);
}

class NetworkError extends UsersState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends UsersState {
  final String message;

  const ErrorState(this.message);
}
