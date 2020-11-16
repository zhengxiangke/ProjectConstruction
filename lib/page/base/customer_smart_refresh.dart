import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///  Created by zhengxiangke
///  des: 下啦 加载 刷新主件
// ignore: must_be_immutable
class CustomerSmartRefresh extends StatefulWidget {
  Function onRefresh;
  Function onLoading;
  List<dynamic>  mDataList;
  Function(BuildContext context, int index) itemBuilder;
  Widget emptyView;

  CustomerSmartRefresh({this.onRefresh, this.onLoading, @required this.mDataList, this.emptyView, @required  this.itemBuilder});

  @override
  _CustomerSmartRefreshState createState() => _CustomerSmartRefreshState();
}

class _CustomerSmartRefreshState extends State<CustomerSmartRefresh> {
  RefreshController _refreshController =  RefreshController(initialRefresh: false);
//  ///刷新
//  void _onRefresh() async{
//    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
//    // if failed,use refreshFailed()
//    _refreshController.refreshCompleted();
//  }
//  /// 加载
//  void _onLoading() async{
//    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
//    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length+1).toString());
//    if(mounted)
//      setState(() {
//
//      });
//    _refreshController.loadComplete();
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  widget.mDataList != null && widget.mDataList.length > 0 ? SmartRefresher(
      enablePullDown: widget.onRefresh != null ? true : false,
      enablePullUp: widget.onLoading != null ? true : false,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context,LoadStatus mode){
          Widget body ;
          if(mode==LoadStatus.idle){
            body =  Text("pull up load");
          }
          else if(mode==LoadStatus.loading){
            body =  CupertinoActivityIndicator();
          }
          else if(mode == LoadStatus.failed){
            body = Text("Load Failed!Click retry!");
          }
          else if(mode == LoadStatus.canLoading){
            body = Text("release to load more");
          }
          else{
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child:body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: () {
        if (widget.onRefresh != null) {
          widget.onRefresh();
        }
        _refreshController.refreshCompleted();
      },
      onLoading: () async{
        if (widget.onLoading != null) {
          await widget.onLoading();
        }
        _refreshController.loadComplete();
      },
      child: ListView.builder(
        itemBuilder: widget.itemBuilder,
        itemCount: widget.mDataList.length,
      ),
    ) : widget.emptyView;
  }
}
