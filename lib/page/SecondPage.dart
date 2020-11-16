import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ToastUtil.dart';
import 'package:flutter_app/model/item.dart';
import 'package:flutter_app/model/my_action.dart';
import 'package:flutter_app/page/base/base_page.dart';
import 'package:flutter_app/page/base/customer_smart_refresh.dart';
import 'package:flutter_app/page/empty_view.dart';
import 'package:flutter_app/provider/CounterProvider.dart';
import 'package:flutter_app/route/NavigatorUtil.dart';
import 'package:flutter_app/utils/widget/my_appBar.dart';
import 'package:provider/provider.dart';

///  Created by zhengxiangke
///  des:SmartRefresh 基本使用 和网络请求案例 和架构基本运用熟悉
class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends BasePage<SecondPage> {
  List<String> items = [];
   List<MyAction> actions = [];

  @override
  void initState() {
    super.initState();
    actions.add(MyAction(title: '分享', onTap: () {
      /// 点击了分享
      ToastUtil.showToast('点击了分享', context);
    }));
    /// 网络示范
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sendHttp();
    });
  }

  void sendHttp() {
    showLoadingView();
    request('/jvs-app-shop/inventoryTask/task/getTaskCountsList',
        method: 'GET', showLoading: false, onSuccess: (data) {
          /// 加强代码健壮 mounted= true 代表页面没销毁
          /// 一般和setStatusu一起用
          closeFailedAndLoadingView();
          items = ["1", "2", "3", "4", "5", "6", "7", "8"];
          setState(() {
    
          });
    //            if (mounted) {
    //              List<Item> items = [];
    //              (data.data as List).forEach((element) {
    //                items.add(Item.fromJson(element));
    //              });
    //            }
        }, onFail: () {
          items = ["1", "2", "3", "4", "5", "6", "7", "8"];
          closeFailedAndLoadingView();
        });
  }
@override
  Widget buildAppBar() {
    return  MyAppBar(
        title: '第二个页面${context.watch<CounterProvider>().count}',
        actions: actions,
        onBackCallback: () {
          Navigator.of(context).pop(context);
        },
      );
  }
  @override
  Widget buildBody() {
    return CustomerSmartRefresh(
        onRefresh: () {

        },
        onLoading: () async{
          await Future.delayed(Duration(milliseconds: 10000), () {
            items= ['xx'];
            setState(() {});
          });

        },
        mDataList: items,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              NavigatorUtil.pushName(context, '/NestedScrollViewDemo', arguments: {'value' : 'value'});
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(items[index]),
            ),
          );
        },
        emptyView: EmptyView(
          btnMsg: '重试',
          onTap: () {
            onRetry();
          },
        ),
      );
  }

  @override
  void onRetry() {
    super.onRetry();
    sendHttp();
  }

}
