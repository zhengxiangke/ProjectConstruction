import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/CounterProvider.dart';
import 'package:flutter_app/utils/widget/my_appBar.dart';
import 'package:provider/provider.dart';

import 'base/base_page.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
as extended;
///  Created by zhengxiangke
///  des:
class NestedScrollViewDemo extends StatefulWidget {
  String value;

  NestedScrollViewDemo({this.value});

  @override
  _NestedScrollViewDemoState createState() => _NestedScrollViewDemoState();
}

class _NestedScrollViewDemoState extends BasePage<NestedScrollViewDemo> with TickerProviderStateMixin{
  TabController primaryTC;
  ScrollController sc = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    closeFailedAndLoadingView();
    primaryTC = TabController(length: 3, vsync: this);


  }
  @override
  Widget buildAppBar() {
    // TODO: implement buildAppBar
    return  null;
  }

  @override
  Widget buildBody() {
    return NestedScrollViewRefreshIndicator(
      onRefresh: () {
        return Future<bool>.delayed(const Duration(seconds: 1), () {
          return true;
        });
      },
      child: extended.NestedScrollView(
        controller: sc,

        headerSliverBuilder: ( context,  innerBoxIsScrolled) {
          return <Widget> [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
          //centerTitle: true,
          collapseMode: CollapseMode.pin,
          background: Image.asset(
          'images/467141054.jpg',
          fit: BoxFit.fill,
          )
          ),
              title: Text('${widget.value}${context.watch<CounterProvider>().count}',
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
              elevation: 0,
              leading: IconButton(
                color: Color(0xff333333),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              ),
              backgroundColor: Color.fromRGBO(0xff, 0xff, 0xff, 1),
            )
//            MyAppBar('优惠劵')
          ];
        },

        pinnedHeaderSliverHeightBuilder: () {
          return kToolbarHeight + MediaQuery.of(context).padding.top;
        },
        innerScrollPositionKeyBuilder: () {
          var index = 'Tab';
          index += primaryTC.index.toString();
          return Key(index);
        },
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: TabBar(
                controller: primaryTC,
                labelColor: Color(0xff5688A8),
                indicatorColor: Color(0xff5688A8),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2.0,
                isScrollable: false,
                onTap: (index) {

                },
                unselectedLabelColor: Color(0xff666666),
                tabs: const <Tab>[
                  Tab(text: '可使用'),
                  Tab(text: '已使用'),
                  Tab(text: '已过期'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: primaryTC,
                children: <Widget>[
                  NestedScrollViewInnerScrollPositionKeyWidget(Key('Tab0'), Container(
                    child: Text('1'),
                  )),
                  NestedScrollViewInnerScrollPositionKeyWidget(Key('Tab1'), Container(
                    child: Text('2'),
                  )),
                  NestedScrollViewInnerScrollPositionKeyWidget(Key('Tab2'), Container(
                    child: Text('3'),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text(widget.value),),
//      body: Container(
//        color: Colors.blue,
//        child: Text(widget.value),
//      ),
//    );
//  }
}
