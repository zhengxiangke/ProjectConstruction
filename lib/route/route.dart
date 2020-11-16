import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/SecondPage.dart';
import 'package:flutter_app/page/NestedScrollViewDemo.dart';
import 'package:flutter_app/page/provider_demo.dart';

///  Created by zhengxiangke
///  des:
final routes = {
  '/second' : (context) => SecondPage(),
  '/NestedScrollViewDemo' : (context, {arguments}) => NestedScrollViewDemo(value: arguments['value'] as String),
  '/ProviderDemo': (context) => ProviderDemo()
};

// ignore: missing_return, top_level_function_literal_block
final onGenerateRoute = (settings) {
  Function pageContentBuilder = routes[settings.name];
  Route route;
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      /// 传递参数
      route = MaterialPageRoute(
          settings: settings,
          builder: (context) => pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      /// 不传递参数 只管跳
      route = MaterialPageRoute(
          settings: settings,
          builder: (context) => pageContentBuilder(context));
      return route;
    }

  }
};