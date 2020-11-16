import 'package:alice/alice.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/Application.dart';

import 'custom_interceptors.dart';

///  Created by zhengxiangke
///  des:、
/// 这个是域名  请书写自己项目中的域名
const String BASEURL = '';
class HttpConfig {
  static const baseUrl = BASEURL;
  static const timeout = 5000;

  static const codeSuccess = 10000;

}

class HttpManager {
  factory HttpManager() => getInstance();
  static HttpManager get install => getInstance();
  static HttpManager _install;
  static Dio dio;
  HttpManager._internal() {
    // 初始化
  }
  static HttpManager getInstance() {
    if (_install == null) {
      _install = HttpManager._internal();
    }
    return _install;
  }
  /// 初始化网络配置
  static void initNet() {
    dio = Dio(BaseOptions(
      baseUrl: HttpConfig.baseUrl,
      contentType: 'application/x-www-form-urlencoded',
      connectTimeout: HttpConfig.timeout,
      receiveTimeout: HttpConfig.timeout
    ));
    if (Application.proxy) {
      /// 用于代理 抓包
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        client.findProxy = (uri) {
          //// PROXY 是固定  后面的localhost:8888 指的是别人的机器ip
          return 'PROXY localhost:8888';
        };
      };
    }
    /// 添加拦截器
    dio.interceptors.add(CustomInterceptors());

    dio.interceptors.add(Application.alice.getDioInterceptor());
  }

}