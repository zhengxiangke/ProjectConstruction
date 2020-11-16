import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/model/item.dart';
import 'package:flutter_app/netservice/http_manager.dart';
import 'package:flutter_app/netservice/result_data.dart';
import 'package:flutter_app/utils/widget/loading.dart';
import 'package:flutter_app/utils/widget/loading_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

///  Created by zhengxiangke
///  des:
class HttpRequest {
  /// 公共的Http 请求
  static  request<T>(String path,
      {String method = 'POST',
      var data,
      var queryParameters,
      String contentType = Headers.formUrlEncodedContentType,
      bool isShowError = true, Function(ResultData) onSuccess, Function onFail}) async {
    try {
      var response = await HttpManager.dio.request(path,
              data: data,
              queryParameters: queryParameters,
              options: Options(
                  method: method,
                  contentType: contentType,
                  responseType: ResponseType.plain));
      Map<String, dynamic> dataMap = {};
      if (response.statusCode == 200) {
        /// http 请求成功
        if (response.data != null) {
          if (response.data is String) {
            dataMap = json.decode(response.data as String);
          } else {
            dataMap = response.data ?? {};
          }
          if (isShowError && dataMap['code'] != HttpConfig.codeSuccess.toString()) {
            Fluttertoast.showToast(msg: dataMap['content'] ?? '未知异常');
          }
        }
        /// 请求成功 可根据你的实际情况修改
        var data =  ResultData(
            data: dataMap['data'],
            code: dataMap['code'] ?? HttpConfig.codeSuccess,
            content: dataMap['content']);
        if (onSuccess != null) {
          onSuccess(data);
        }
      } else {
        if (onFail != null) {
//        var data =  ResultData(data: null, code: response.statusCode.toString());
          onFail();
        }
      }
    } catch (e) {
      if (e is DioError) {
        if (onFail != null) {
          onFail();
        }
      }
    }
  }

//  ///具体的请求业务
// static Future<ResultData> requestUserInfo<T>(String path,
//      {String method = 'POST',
//        var data,
//        var queryParameters,
//        String contentType = Headers.formUrlEncodedContentType,
//        bool isShowError = true, Function(List<Item>) onSuccess}) {
//
//    request(path, method:method , data: data, contentType: contentType, isShowError: true).then((value) {
//      if (value.code == HttpConfig.codeSuccess.toString()) {
//        /// 请求成功
//        List<Item> data = [];
//        value.data.forEach((v) {
//          data.add(Item.fromJson(v));
//        });
//        if (onSuccess != null) {
//          onSuccess(data);
//        }
//      }
//      /// 失败不做处理 因为在里面已经toast 当然你这里可以自定义处理对自己的业务
//    });
//  }

}
