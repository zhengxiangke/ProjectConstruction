import 'package:flutter/cupertino.dart';

///  Created by zhengxiangke
///  des: 对用户行为流的埋点监测 在这里可以进行简单的埋点上报
class GLObserver extends NavigatorObserver{
  ///route 指的是push 的路由
  ///previousRoute  上一个路由
  ///eg page1 =>page2 route=page2    previousRoute=page1
  @override
  void didPush(Route route, Route previousRoute) {
    // TODO: implement didPush
    super.didPush(route, previousRoute);
    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    }else {
      previousName = previousRoute.settings.name;
    }
    try {
//      print('NavObserverDidPush-Current:' + route.settings.name + '  Previous:' + previousName );
    } catch (e) {
      print(e);
    }

  }
  ///route 指的是pop 掉当前路由
  ///previousRoute  上一个路由
  ///eg pop page2=>page1 route=page2  previousRoute= page1
  @override
  void didPop(Route route, Route previousRoute) {
    // TODO: implement didPop
    super.didPop(route, previousRoute);
    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    }else {
      previousName = previousRoute.settings.name;
    }
    try {
//      print('NavObserverDidPop--Current:' + route.settings.name + '  Previous:' + previousName);
    } catch (e) {
      print(e);
    }
  }
}