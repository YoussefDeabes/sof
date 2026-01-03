import 'package:sof/core/network/api_keys.dart';
import 'package:sof/core/network/base/base_api_manager.dart';
import 'package:sof/core/network/errors/network_exceptions.dart';
import 'package:sof/features/users/data/models/reputation_history_list_wrapper.dart';
import 'package:sof/features/users/data/models/users_list_wrapper.dart';

class UsersApiManager {
  static Future<void> getUsers(
    int pageNumber,
    void Function(UsersListWrapper) success,
    void Function(NetworkExceptions) fail,
  ) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .get(
          ApiKeys.users,
          queryParameters: {
            'site': 'stackoverflow',
            'order': 'desc',
            'sort': 'reputation',
            'pagesize': 20,
            'page': pageNumber,
          },
        )
        .then((response) {
          Map<String, dynamic> extractedData =
              response.data as Map<String, dynamic>;
          UsersListWrapper wrapper = UsersListWrapper.fromJson(extractedData);
          success(wrapper);
        })
        .catchError((onError) {
          fail(NetworkExceptions.getDioException(onError));
        });
  }

  static Future<void> getReputationHistory(
    num userId,
    int pageNumber,
    void Function(ReputationHistoryListWrapper) success,
    void Function(NetworkExceptions) fail,
  ) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .get(
          'https://api.stackexchange.com/2.2/users/$userId/reputation-history',
          queryParameters: {
            'site': 'stackoverflow',
            'page': pageNumber,
            'pagesize': 30,
          },
        )
        .then((response) {
          Map<String, dynamic> extractedData =
              response.data as Map<String, dynamic>;
          ReputationHistoryListWrapper wrapper =
              ReputationHistoryListWrapper.fromJson(extractedData);
          success(wrapper);
        })
        .catchError((onError) {
          fail(NetworkExceptions.getDioException(onError));
        });
  }
}

