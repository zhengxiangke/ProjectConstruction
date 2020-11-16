import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///  Created by zhengxiangke
///  des: 空视图
class EmptyView extends StatelessWidget {
  ///提示文案  eg:您目前暂无优惠券，快去领券中心领取吧！
  final String hintMsg;
  ///按钮文字
  final String btnMsg ;
  //images/empty_coupon.png  图片本地路径
  final String emptyasset;
  ///按钮点击回掉
  final Function onTap;
  EmptyView({Key key,
    this.hintMsg = '暂无数据',
    @required this.btnMsg,
    this.onTap,
    this.emptyasset= 'images/timg.jpeg'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(emptyasset, width: 100, height: 80,),
            SizedBox(height: 22,),
            Text(hintMsg, style: TextStyle(fontSize: 13, color: Color(0xff999999)),),
            SizedBox(height: 18,),

            InkWell(
              onTap: () {
                if (onTap != null) {
                  onTap();
                }
              },
              child: Container(
                height: 40,
                width: 175,
                decoration: BoxDecoration(
                    color: Color(0xffA5CAE8),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: Text(
                    btnMsg, style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}