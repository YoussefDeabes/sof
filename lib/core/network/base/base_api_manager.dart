import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sof/core/network/api_keys.dart';
import 'package:sof/core/network/base/interceptors.dart';
import 'package:sof/core/network/base/request_form_data_interceptor.dart';
import 'package:sof/core/prefs/pref_manager.dart';

class BaseApi extends BaseOptions {
  static String? langKey;

  static Dio get dio {
    Dio updatedDio = _dioInstance()
      ..interceptors.addAll([
        InterceptorsWrapper(
          onError: (DioException error, handler) async {
            return handler.next(error);
          },
        ),
      ]);

    if (kDebugMode) {
      updatedDio.interceptors.addAll([
        logInterceptor,
        RequestFormDataInterceptor(),
      ]);
    }
    return updatedDio;
  }

  static Future<void> updateHeader() async {
    langKey = await PrefManager.getLang();
  }

  static Dio _dioInstance() {
    return Dio(
      BaseApi()
        ..validateStatus = (status) =>
            status != null && status >= 200 && status < 300,
    );
  }

  @override
  Map<String, dynamic> get headers {
    Map<String, dynamic> header = {};
    header.putIfAbsent(ApiKeys.accept, () => ApiKeys.applicationJson);
    header.putIfAbsent(ApiKeys.acceptLanguage, () => langKey ?? 'en');
    header.putIfAbsent(ApiKeys.contentType, () => ApiKeys.applicationJson);
    return header;
  }

  @override
  String get contentType => super.contentType!;

  @override
  String get baseUrl => ApiKeys.baseUrl;
}
