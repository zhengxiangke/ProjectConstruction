//  Created by zhengxiangke
//  des:
//
 import 'package:flutter/cupertino.dart';

class IUpdateView <T>{
  Function(T msg) callback;
  void updateView (T t) {
    if (callback != null) {
      callback(t);
    }
  }

  IUpdateView({@required this.callback});
}

