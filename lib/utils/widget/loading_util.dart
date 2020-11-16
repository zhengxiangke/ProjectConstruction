import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/widget/loading.dart';

import '../../Application.dart';

///  Created by zhengxiangke
///  des:
class LoadingUtil {
  static OverlayEntry _overlayEntry;

  static void showLoading() {
    if (_overlayEntry != null) return;
    OverlayState _overlayState = Application.globalKey.currentState.overlay;
    _overlayEntry = OverlayEntry(builder: (context) {
      /// top: MediaQuery.of(context).padding.top + kToolbarHeight,
      /// 这样做是为了让标题蓝可以点击 否则网差用户等待时间太长了
      return Positioned(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
          bottom: 0,
          right: 0.0,
          left: 0.0,
          child: Loading());
    });

    _overlayState.insert(_overlayEntry);
  }

  static void closeLoading() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}
