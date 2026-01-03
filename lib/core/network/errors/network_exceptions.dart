import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sof/core/network/errors/exception_types.dart';

class NetworkExceptions {
  /// backend error ...
  int? errorCode;
  final String? errorMsg;

  /// in case you need to add custom message ...
  String get customErrorMessage => "";

  String getErrorMassage() {
    if (errorMsg != null && errorMsg!.isNotEmpty) return errorMsg!;
    return "Unknown error";
  }

  NetworkExceptions(this.errorCode, this.errorMsg);

  NetworkExceptions.fromJson(Map<String, dynamic>? json)
    : errorCode = (json == null || json.isEmpty)
          ? -1
          : (json['status'] ?? json['Status'] ?? -1) as int?,
      errorMsg = (() {
        if (json == null || json.isEmpty) {
          return "Unknown error";
        }
        if (json.containsKey('status') || json.containsKey('Status')) {
          return json['message'] ?? json['Message'] ?? "Unknown error";
        }
        if (json.containsKey('title')) {
          return json['title'] as String?;
        }
        final firstValue = json.values.isNotEmpty ? json.values.first : null;
        if (firstValue is String && (firstValue.startsWith("<!DOCTYPE") || firstValue.startsWith("<html"))) {
          return "Unknown error";
        }
        return "Unknown error";
      })();

  static NetworkExceptions getDioException(error) {
    if (error is Exception || error is DioException) {
      try {
        NetworkExceptions networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = RequestCancelled(
                error.response?.data as Map<String, dynamic>,
              );
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = RequestTimeout(
                error.response?.data as Map<String, dynamic>,
              );
              break;
            case DioExceptionType.connectionError:
              networkExceptions = NoInternetConnection();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = SendTimeout(
                error.response?.data as Map<String, dynamic>,
              );
              break;
            case DioExceptionType.badResponse:
              networkExceptions = getResponseException(error);
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = SendTimeout(
                error.response?.data as Map<String, dynamic>,
              );
              break;
            default:
              networkExceptions = RequestTimeout(
                error.response?.data as Map<String, dynamic>,
              );
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = UnExpectedError();
        } else {
          networkExceptions = UnexpectedError();
        }
        return networkExceptions;
      } catch (e) {
        return UnexpectedError();
      }
    } else {
      return UnexpectedError();
    }
  }

  static NetworkExceptions getResponseException(DioException error) {
    final statusCode = error.response?.statusCode ?? -1;
    final data = error.response?.data;

    Map<String, dynamic>? dataMap;
    if (data is Map<String, dynamic>) {
      dataMap = data;
    } else if (data == null || (data is String && data.trim().isEmpty)) {
      dataMap = <String, dynamic>{};
    } else {
      dataMap = {'message': data.toString()};
    }

    switch (statusCode) {
      case 400:
      case 403:
        return UnauthorizedRequest(dataMap);
      case 404:
        return NotFound(dataMap);
      case 409:
        return Conflict(dataMap);
      case 408:
        return RequestTimeout(dataMap);
      case 422:
        return UnProcessableEntity(dataMap);
      case 500:
        return InternalServerError(dataMap);
      case 503:
        return ServiceUnavailable(dataMap);
      default:
        return UnexpectedError();
    }
  }
}

