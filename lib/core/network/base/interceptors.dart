import 'dart:developer';

import 'package:dio/dio.dart';

final LogInterceptor logInterceptor = LogInterceptor(
    responseBody: true,
    requestBody: true,
    error: true,
    logPrint: (obj) {
        log(obj.toString());
        print(obj);
    });

