import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/netservice/http_request.dart';
import 'package:flutter_app/netservice/result_data.dart';
import 'package:flutter_app/utils/widget/loading.dart';
import 'package:flutter_app/utils/widget/loading_util.dart';

import '../empty_view.dart';

///  Created by zhengxiangke
///  des:基础的widget
 abstract class BasePage<T extends StatefulWidget> extends State<T>{
   /// 展示加载
   var showLoadView = true;
   ///展示失败视图
   var showFailView = false;
  @override
  void initState() {
    super.initState();
    /// 在这里可以做些简单的页面打开的埋点
  }


  ///加载
  void showLoading() {
    LoadingUtil.showLoading();
  }
  /// 关闭加载
  void closeLoading() {
    LoadingUtil.closeLoading();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          buildBody(),
          showFailView ? EmptyView(
            btnMsg: '重试',
            onTap: () {
              onRetry();
            },
          ) : Container(),
          showLoadView ? Loading() : Container(),


        ],
      ),
    );

  }
  /// 标题蓝抽象方法  这里 在具体的实现类中实现
    Widget buildAppBar() {
      return null;
    }

    Widget buildBody();

    void showLoadingView() {
      showLoadView = true;
      showFailView = false;
      setState(() {

      });
    }
    void closeLoadingView() {
      showLoadView = false;
      setState(() {

      });
    }

    void showFailedView() {
      showFailView = true;
      showLoadView = false;
      setState(() {

      });
    }
    void closeFailedView () {
      showFailView = false;
      setState(() {

      });
    }
    closeFailedAndLoadingView () {
      showFailView = false;
      showLoadView = false;
      setState(() {

      });
    }
   /// 重试方法
   void onRetry() {
      showFailedView();
   }


   /// 请求
   void request<T>(String path,
       {String method = 'POST',
         var data,
         var queryParameters,
         bool showLoading = true,
         String contentType = Headers.formUrlEncodedContentType,
         bool isShowError = true, Function(ResultData) onSuccess, Function onFail}) {
     if (showLoading) {
       LoadingUtil.showLoading();
     }
     HttpRequest.request(path,
         method: method,data: data,
         queryParameters: queryParameters,
         contentType: contentType, isShowError: isShowError,
         onFail: onFail,
         onSuccess: onSuccess);
   }

}


