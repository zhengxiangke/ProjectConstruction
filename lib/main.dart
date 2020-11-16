import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Application.dart';
import 'package:flutter_app/netservice/http_manager.dart';
import 'package:flutter_app/page/SecondPage.dart';
import 'package:flutter_app/page/NestedScrollViewDemo.dart';
import 'package:flutter_app/provider/CounterProvider.dart';
import 'package:flutter_app/route/GLObserver.dart';
import 'package:flutter_app/route/route.dart';
import 'package:flutter_app/utils/common_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/item.dart';
import 'netservice/http_request.dart';

void main() {
  /// 捕获flutter能try catch 捕获的异常
  /// 还有一些异常是try catch 捕获不到的  用runZoned
  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    if (Application.debug) {
      /// 测试环境 日志直接打印子啊控制台
      FlutterError.dumpErrorToConsole(errorDetails);
    } else {
      /// 在生产环境上 重定向到runZone 处理
      Zone.current
          .handleUncaughtError(errorDetails.exception, errorDetails.stack);
    }
    reportErrorAndLog(errorDetails);
  };
  WidgetsFlutterBinding.ensureInitialized();
  GlobalKey<NavigatorState> globalKey = new GlobalKey<NavigatorState>();
  Application.globalKey = globalKey;

  /// dio 网络抓包工具配置
  Alice alice = Alice(
      showInspectorOnShake: true,
      showNotification: true,
      navigatorKey: globalKey);
  Application.alice = alice;

  /// 初始化网络配置
  HttpManager.initNet();

  /// 捕获try catch 捕获不到的异常
  runZoned(
      () => runApp(MultiProvider(
            providers: [
              ///注册通知
              /// 这个是相当于通知 的作用 用于 这个类中的属性改变 然后通知到用到的页面 进行刷新
              ChangeNotifierProvider(create: (_) => CounterProvider()),
            ],
            child: MyApp(),
          )), zoneSpecification: ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      /// 这里捕获所有print 日志
    },
  ), onError: (Object obj, StackTrace stack) {
    var detail = makeDetails(obj, stack);
    reportErrorAndLog(detail);
  });
}

void reportErrorAndLog(FlutterErrorDetails errorDetails) {
  /// 错误日志上报 服务器
}

/// 构建错误信息
FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
  FlutterErrorDetails details =
      FlutterErrorDetails(stack: stack, exception: obj);
  return details;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        //print("change language");
        return locale;
      },
      navigatorKey: Application.globalKey,

      /// 这个routes 不能写  如果写了的话 就不能传递参数
//      routes: routes,
      /// 这个既可以传递参数 也可以不传递参数 用这一个就够了 无须用这个routes
      onGenerateRoute: onGenerateRoute,
      navigatorObservers: [
        /// 路由监听  作用：对用户行为流的埋点监测
        GLObserver()
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Application.debug) {
        _createApiButton(MediaQuery.of(context).padding.top + 200.0, 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('示例${context.watch<CounterProvider>().count}'),
      ),
      body: Center(
        child: Column(
          children: [
            InkWell(
                onTap: () {
//                CommonDialog.show(context, title: '标题', content: '内容');

                  Navigator.of(context).pushNamed('/NestedScrollViewDemo',
                      arguments: {'value': 'NestedScrollViewDemo'});
                },
                child: MaterialButton(
                    child: Text(
                  'NestedScrollViewDemo 基本使用',
                  style: TextStyle(fontSize: 20),
                ))),
            InkWell(
                onTap: () {
//                CommonDialog.show(context, title: '标题', content: '内容');

                  Navigator.of(context).pushNamed('/second');
                },
                child: MaterialButton(
                    child: Text(
                  '基本架构理解和使用',
                  style: TextStyle(fontSize: 20),
                ))),
            InkWell(
                onTap: () {
//                CommonDialog.show(context, title: '标题', content: '内容');

                  Navigator.of(context).pushNamed('/ProviderDemo');
                },
                child: MaterialButton(
                    child: Text(
                  'Provider 通知刷新使用',
                  style: TextStyle(fontSize: 20),
                ))),
          ],
        ),
      ),
    );
  }

  /// 添加全局的 网络图标  点击可以查看alice
  void _createApiButton(double top, double left) {
    if (Application.network != null) {
      Application.network.remove();
    }
    Widget button = RaisedButton(
      color: Colors.white.withOpacity(0.1),
      onPressed: () {
        Application.alice.showInspector();
      },
      child: Text(
        'Network',
        style: TextStyle(color: Colors.black),
      ),
    );
    var overlayState = Application.globalKey.currentState.overlay;
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              top: top,
              left: left,
              child: Draggable(
                onDragEnd: (draggableDetails) {
                  _createApiButton(
                      draggableDetails.offset.dy, draggableDetails.offset.dx);
                },
                child: button,
                feedback: button,
                childWhenDragging: Container(
                  width: 0.0,
                  height: 0.0,
                ),
              ),
            ));
    overlayState.insert(overlayEntry);
    Application.network = overlayEntry;
  }
}
