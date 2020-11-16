import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///  Created by zhengxiangke
///  des: 公共的对话框 提供标题 内容 取消 确定按钮
class CommonDialog {
  static void show(BuildContext context,
      {String title,
      String content = '',
      bool barrierDismissible = true,
      String cancelText = '取消',
      String okText = '确定',
      Function onCancel,
      Function onOk}) {
    showGeneralDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(.5),
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Center(
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        title != null
                            ? Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                child: Text(title,
                                    style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        inherit: false)),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        Container(
                          padding: EdgeInsets.only(bottom: 16, top: 16),
                          child: Text(content,
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  inherit: false)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 16, right: 16, left: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              child: Material(
                                color: Color(0xffA4CAE8).withOpacity(0.3),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).maybePop();
                                    if (onCancel != null) {
                                      onCancel();
                                    }
                                  },
                                  child: Container(
                                    width: 120,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 24),
                                    child: Text(cancelText,
                                        style: TextStyle(
                                            color: Color(0xff5688A8),
                                            fontSize: 16,
                                            inherit: false)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              child: Material(
                                color: Color(0xff85C0FF),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).maybePop();
                                    if (onOk != null) {
                                      onOk();
                                    }
                                  },
                                  child: Container(
                                    width: 120,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 24),
                                    child: Text(okText,
                                        style: TextStyle(
                                            color: Color(0xffffffff),
                                            fontSize: 16,
                                            inherit: false)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
