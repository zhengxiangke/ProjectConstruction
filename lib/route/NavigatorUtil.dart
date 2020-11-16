import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///  Created by zhengxiangke
///  des:
class NavigatorUtil {
  ///直接跳转
  static void push(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  ///根据路径跳转 可传参数
  static void pushName(BuildContext context, String name, {Object arguments}) {
    Navigator.pushNamed(context, name, arguments: arguments);
  }

  ///销毁页面
  static void pop(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  /// 推到 指定路由页面 这指定路由页面上的页面全部销毁
  /// 注意： 若果没有指定路由 会报错
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }


  /// 把当前页面在栈中的位置替换为跳转的页面， 当新的页面进入后，之前的页面将执行dispose方法
  static void pushReplacementNamed(BuildContext context, String routeName,
      {Object arguments}) {

    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }
}