import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/my_action.dart';
import 'package:flutter_app/utils/widget/loading_util.dart';

///  Created by zhengxiangke
///  des:
class MyAppBar extends StatefulWidget implements PreferredSizeWidget{

  final dynamic title;
  final List<MyAction> actions;
  Function onBackCallback;

  MyAppBar({this.title = '', this.actions, this.onBackCallback});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}
class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: Color(0xffffffff),
      leading: IconButton(
        color: Color(0xff333333) ,
        icon: Icon(Icons.arrow_back_ios, size: 20,),
        onPressed: () {
          /// 用户操作了返回键 但是加载框还能在前一页显示问题
          LoadingUtil.closeLoading();
          if (widget.onBackCallback != null) {

            widget.onBackCallback();
          } else {
            Navigator.of(context).pop(context);
          }
        },
      ),
      centerTitle: true,
      title:  Text(widget.title as String,
          style: TextStyle(
              color: Color(0xff333333),
              fontSize: 18,
              fontWeight: FontWeight.w400)),
      actions: (widget.actions ?? <MyAction>[]).map((e) => Material(
        color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (e.onTap != null) {
                e.onTap();
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                e.title,
                style: TextStyle(
                    color: Color(0xff5F99D4),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
      )).toList(),
    );
  }

}