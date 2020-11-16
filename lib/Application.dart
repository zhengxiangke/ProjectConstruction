//  Created by zhengxiangke 
//  des:
//
  import 'package:alice/alice.dart';
import 'package:flutter/cupertino.dart';
class Application {
  ///应用全局 ke
   static GlobalKey<NavigatorState>  globalKey;
   static OverlayEntry network;
   /// 默认不代理  可用于抓包
   static bool proxy = false;
   static Alice alice;
   /// 是否测试 可打印日志
   static const debug = true;
}
