//  Created by zhengxiangke
//  des:
//
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/utils/update_view.dart';
///这是一个例子
///这个在initState() 注册   <> 里的类型 要跟 发送的数据类型对应  可以是String int bool  还有model list
///    IUpdateViewManager.instance.registerIUPdateView(UpdateView(NoticeAction.action1,
///      IUpdateView<List<String>>(
///         callback: (List<String> msg) {
///           print(msg);
///            }
///     )));、
///发送通知  注意 这里可以发送任何类型的数据 因为范型
///IUpdateViewManager.instance.notifyIUpdateView(NoticeAction.action1, ['xx', 'vvv']);
///在dispose中 取消注册  注意： 有注册就有取消  这是对应的 否则会出现功能不正常请客
///IUpdateViewManager.instance.unRegistIUpdateView(NoticeAction.action1);
class IUpdateViewManager{
  List<UpdateView> updateViews = [];

  // 工厂模式
  factory IUpdateViewManager() =>_getInstance();
  static IUpdateViewManager get instance => _getInstance();
  static IUpdateViewManager _instance;
  IUpdateViewManager._internal() {
    // 初始化
  }
  static IUpdateViewManager _getInstance() {
    _instance ??= IUpdateViewManager._internal();
    return _instance;
  }
  ///注册通知 在initstatus 注册
  void registerIUPdateView(UpdateView updateView) {
      ///在数组中不能存在多个相同的action
    updateViews.insert(0, updateView);
  }
  ///发送通知  在业务场景需要的地方 调用这个方法
  void notifyIUpdateView <T>(String action, T t) {
    if (updateViews != null && updateViews.isNotEmpty) {
      for (var item in updateViews) {
        if (item.action == action) {
          item.iUpdateView.updateView(t);
          break;
        }
      }
    }
  }
  ///通知解绑  在dispose方法中解绑 注意 有注册 就有解绑 这是一定必须的
  void unRegistIUpdateView(String action) {
    if (updateViews != null && updateViews.isNotEmpty) {
      updateViews.remove(UpdateView(action, null));
    }
  }
}
///这个类是时间action  用到这个类的通知的action 在这里定义常量
class NoticeAction {
  static const String action1 = 'action1';
  static const String action2 = 'action2';




}
