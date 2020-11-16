//  Created by zhengxiangke
//  des: 通知类

import 'i_update_view.dart';

class UpdateView {
  String action;
  IUpdateView iUpdateView;


  UpdateView(this.action, this.iUpdateView);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateView &&
          runtimeType == other.runtimeType &&
          action == other.action;

  @override
  int get hashCode => action.hashCode;
}
