import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_video/common/values/config.dart';

class NetWorkUtils {
  static final NetWorkUtils instance =
      NetWorkUtils._initernal(_privateConstructor());
  final Dio _dio;

  NetWorkUtils._initernal(this._dio);

  factory NetWorkUtils() {
    return instance;
  }

  static _privateConstructor() {
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);
    if (openProxy && !isRelease) {
      HttpOverrides.global = DebugHttpOverrides();
    }
    return dio;
  }

  Future<Map<String, dynamic>> getHttp(
      {String? url, Map<String, dynamic>? params}) async {
    Response response = await _dio.get(url ?? "", queryParameters: params);

    if (response.statusCode == HttpStatus.ok) {
      //网络连接成功
      var json = jsonDecode(response.toString());
      //准备解析
      return json;
    }
    return Future.error("$url request error(${response.statusCode})");
  }
}

class DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    var http = super.createHttpClient(context);
    http.findProxy = (uri) {
      return 'PROXY $networkProxy';
    };
    http.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return http;
  }
}
