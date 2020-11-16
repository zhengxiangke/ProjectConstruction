import 'package:flutter/cupertino.dart';

///  Created by zhengxiangke
///  des:
class CounterProvider with ChangeNotifier {
  int count = 0;
  void addCount() {
    count ++;
    notifyListeners();
  }
}