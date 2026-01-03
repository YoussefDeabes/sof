import 'package:sof/core/network/errors/network_exceptions.dart';

class UnProcessableEntity extends NetworkExceptions {
  UnProcessableEntity(super.json) : super.fromJson();

  @override
  String get customErrorMessage => "Unprocessable Entity";
}

class RequestCancelled extends NetworkExceptions {
  RequestCancelled(super.json) : super.fromJson();

  @override
  String get customErrorMessage => "Request Cancelled";
}

class UnauthorizedRequest extends NetworkExceptions {
  UnauthorizedRequest(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => errorMsg ?? "Invalid";
}

class ResponseError extends NetworkExceptions {
  ResponseError(super.json) : super.fromJson();

  @override
  String get customErrorMessage => errorMsg ?? "";
}

class NotFound extends NetworkExceptions {
  NotFound(super.json) : super.fromJson();

  @override
  String get customErrorMessage => "Not Found";
}

class RequestTimeout extends NetworkExceptions {
  RequestTimeout(super.json) : super.fromJson();

  @override
  String get customErrorMessage => "Connection request timeout";
}

class SendTimeout extends NetworkExceptions {
  SendTimeout(super.json) : super.fromJson();

  @override
  String get customErrorMessage => "Send timeout in connection with API server";
}

class Conflict extends NetworkExceptions {
  Conflict(super.json) : super.fromJson();

  @override
  String get customErrorMessage => "Error due to a conflict";
}

class InternalServerError extends NetworkExceptions {
  InternalServerError(super.json) : super.fromJson();

  @override
  String get customErrorMessage => "Internal Server Error";
}

class ServiceUnavailable extends NetworkExceptions {
  ServiceUnavailable(super.json) : super.fromJson();

  @override
  String get customErrorMessage => 'Service unavailable';
}

class UnexpectedError implements NetworkExceptions {
  UnexpectedError();

  @override
  String get customErrorMessage => errorMsg;

  @override
  int? errorCode = -1;

  @override
  String errorMsg = "Unexpected error occurred";

  @override
  String getErrorMassage() {
    return errorMsg;
  }
}

class UnExpectedError implements NetworkExceptions {
  UnExpectedError();

  @override
  String get customErrorMessage => errorMsg;

  @override
  int? errorCode = -1;

  @override
  String errorMsg = "Unexpected error";

  @override
  String getErrorMassage() {
    return errorMsg;
  }
}

class NoInternetConnection implements NetworkExceptions {
  NoInternetConnection();

  @override
  String get customErrorMessage => errorMsg;

  @override
  int? errorCode = -1;

  @override
  String errorMsg = "No internet connection";

  @override
  String getErrorMassage() {
    return errorMsg;
  }
}

