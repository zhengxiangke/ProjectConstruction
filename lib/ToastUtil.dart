//  Created by zhengxiangke 
//  des:
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastUtil {
  ///显示toast
  static void showToast (String msg, BuildContext context) {
    if (context != null) {
      OverlayEntry overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container (
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xffE0E0E0)
                    ),
                    child: Text(msg, style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),),
                  ),
                  Image.asset('images/timg.jpeg',fit: BoxFit.contain, width: 200,)
                ],
              )
      );
      Overlay.of(context).insert(overlayEntry);
      ///显示toast  2秒自动消失
      Future.delayed(Duration(seconds: 2), () {
        overlayEntry.remove();
      } );
    }
  }
}