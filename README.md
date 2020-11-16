# flutter_app

一个项目搭建的架构篇

## Getting Started

### 介绍

> 多姿的青春，迷茫的青春，懵懂的青春，落泪的青春，责任的青春，青春的婀娜，青春的美妙全部撒播在了沿途的风景之中，迷茫，酸楚，欢声笑语在记忆的天空中承载着[梦想](https://www.lz13.cn/mingrenmingyan/4956.html)而飞翔，青春才成了心中的永恒

本文带你一步一步搭建flutter项目架构，方便你项目直接集成使用。项目主要用到以下技术栈，小编秉着分享的宗旨，为你讲解

1.全局捕获异常

2.路由(Route)

3.Dio(网络)

4.OverlayEntry

5.网络dio抓包工具配置(ALice)

6.状态管理(Provider)

7.通知(这个是小编自己写的, 很方便，类似EventBus)

### 全局捕获异常

在Flutter中 ,有些异常是可以捕获到的，有些则是捕获不到的。那么，我们要做到错误日志上报给服务器，方便线上跟踪问题，怎么办呢？有个东西了解一下，捕获不到的用runZoned。代码如下，代码中有详细的注释，这里就不一一解释了。

```
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
```

### 路由相关

#### 路由跳转配置

跳转有2种方式。一种是直接用Widget， 另一种是用routeName。 这里小编为你讲解routeName跳转

先附上路由跳转封装类

> ```
> import 'package:flutter/cupertino.dart';
> import 'package:flutter/material.dart';
> 
> ///  Created by zhengxiangke
> ///  des:
> class NavigatorUtil {
> ///直接跳转
> static void push(BuildContext context, Widget widget) {
>  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
> }
> 
> ///根据路径跳转 可传参数
> static void pushName(BuildContext context, String name, {Object arguments}) {
>  Navigator.pushNamed(context, name, arguments: arguments);
> }
> 
> ///销毁页面
> static void pop(BuildContext context) {
>  Navigator.of(context).pop(context);
> }
> 
> /// 推到 指定路由页面 这指定路由页面上的页面全部销毁
> /// 注意： 若果没有指定路由 会报错
> static void popUntil(BuildContext context, String routeName) {
>  Navigator.popUntil(context, ModalRoute.withName(routeName));
> }
> 
> 
> /// 把当前页面在栈中的位置替换为跳转的页面， 当新的页面进入后，之前的页面将执行dispose方法
> static void pushReplacementNamed(BuildContext context, String routeName,
>    {Object arguments}) {
> 
>  Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
> }
> }
> ```

我们可以看到代码中的routeName, routeName这个是我们自己可以配置的 ，简单而言，就是根据路径去跳到指定的页面。路由配置如下

```
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

```

```
final routes = {
  '/second' : (context) => SecondPage(),
  '/NestedScrollViewDemo' : (context, {arguments}) => NestedScrollViewDemo(value: arguments['value'] as String),
  '/ProviderDemo': (context) => ProviderDemo()
};

// ignore: missing_return, top_level_function_literal_block
final onGenerateRoute = (settings) {
  Function pageContentBuilder = routes[settings.name];
  Route route;
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      /// 传递参数
      route = MaterialPageRoute(
          settings: settings,
          builder: (context) => pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      /// 不传递参数 只管跳
      route = MaterialPageRoute(
          settings: settings,
          builder: (context) => pageContentBuilder(context));
      return route;
    }

  }
};
```

#### 观察者

页面跳转添加观察者，能获取用户行为数据（GLObserver）



```
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
```

### Dio相关

dio是一个强大的Dart Http请求库，支持Restful API、FormData、拦截器、请求取消、Cookie管理、文件上传/下载、超时、自定义适配器等...

```
dependencies:
  dio: ^3.0.9  // 请使用pub上3.0.0分支的最新版本
```

####  基本配置

小编带你写个Dio单例， 在这个单例中配置Dio基本配置

```
/// 这个是域名  请书写自己项目中的域名
const String BASEURL = '';
class HttpConfig {
  static const baseUrl = BASEURL;
  static const timeout = 5000;

  static const codeSuccess = 10000;

}

class HttpManager {
  factory HttpManager() => getInstance();
  static HttpManager get install => getInstance();
  static HttpManager _install;
  static Dio dio;
  HttpManager._internal() {
    // 初始化
  }
  static HttpManager getInstance() {
    if (_install == null) {
      _install = HttpManager._internal();
    }
    return _install;
  }
  /// 初始化网络配置
  static void initNet() {
    dio = Dio(BaseOptions(
      baseUrl: HttpConfig.baseUrl,
      contentType: 'application/x-www-form-urlencoded',
      connectTimeout: HttpConfig.timeout,
      receiveTimeout: HttpConfig.timeout
    ));
  }

}
```

####  设置代理

有这么个需求背景， 有一天，测试来问，怎么抓网络信息。Dio 为我们提供了代理， 测试可以根据chanles等抓包工具进行查看网络信息

```
    if (Application.proxy) {
      /// 用于代理 抓包
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        client.findProxy = (uri) {
          //// PROXY 是固定  后面的localhost:8888 指的是别人的机器ip
          return 'PROXY localhost:8888';
        };
      };
    }
```

#### 拦截器

我们可以在拦截器中添加一些公共的参数，如用户信息，手机信息，App版本信息等等， 也可以打印请求的url, 请求头，请求体信息。也可以进行参数签名。这里签名就不一一说了，

```
  /// 添加拦截器
    dio.interceptors.add(CustomInterceptors());
    
```

```
///  des:  这里的api 规范是 200成功
class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    /// 在拦截里设置公共请求头
    options.headers = {HttpHeaders.authorizationHeader: '这是token'};
    if (Application.debug) {
      try {
        print("请求url：${options.path}");
        print('请求头: ' + options.headers.toString());
        /// 可以在这里个性定制 如签名 key value 从小到大排序 options.data  再次赋值即可
        print('请求体: ' + options.data);
      } catch (e) {
        print(e);
      }
    }
    return super.onRequest(options);
  }
  @override
  Future onResponse(Response response) async{
    LoadingUtil.closeLoading();
    if (Application.debug) {
      print('code=${response.statusCode.toString()} ==data=${response.data
          .toString()}');
    }
      return super.onResponse(response);
  }
  @override
  Future onError(DioError err) {
    // TODO: implement onError
    LoadingUtil.closeLoading();
    if (err.type == DioErrorType.CONNECT_TIMEOUT
        || err.type == DioErrorType.RECEIVE_TIMEOUT
         || err.type == DioErrorType.SEND_TIMEOUT) {
      Fluttertoast.showToast(msg: '请求超时');
    } else {
      Fluttertoast.showToast(msg: '服务异常');
    }
    return super.onError(err);
  }
}
```

### ALice

这是一个网络请求查看库，有了这个就不需要指定代理了，很方便。下面为dio 进行Alice 拦截，以便查看Dio 发出的请求 

[Alice]: https://pub.flutter-io.cn/packages/alice

```
dependencies:
  alice: 0.1.4
  dio.interceptors.add(Application.alice.getDioInterceptor());
```

注意：ALice 一定要配置navigatorKey

```
  GlobalKey<NavigatorState> globalKey = new GlobalKey<NavigatorState>();
  Application.globalKey = globalKey;
    /// dio 网络抓包工具配置
  Alice alice = Alice(
      showInspectorOnShake: true,
      showNotification: true,
      navigatorKey: globalKey);
  Application.alice = alice;
```

```
  class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(		       navigatorKey:Application.globalKey,
      ],
      home: MyHomePage(),
    );
  }
}
```

### Provider

Flutter 状态管理，实际来说就是数据和视图的绑定和刷新； 这块对应到 H5，就比较好理解，这个概念也是从前端来到； 对应到 客户端，就是监听回调，类似事件总线（EventBus）

简而言之，就是监听的类中的变量属性发生变化就会刷新用到这个变量的Widget 页面

```
dependencies:
	provider: ^4.3.2+2
```

说说这个库的中心思想 

1.注册

2.定义类

3.赋值

4.取值

 ####  注册

```
runApp(MultiProvider(
            providers: [
              ///注册通知
              /// 这个是相当于通知 的作用 用于 这个类中的属性改变 然后通知到用到的页面 进行刷新
            ChangeNotifierProvider(create: (_) => CounterProvider()),
            ],
            child: MyApp(),
          ))
```

#### 定义类

```
class CounterProvider with ChangeNotifier {
  int count = 0;
  void addCount() {
    count ++;
    notifyListeners();
  }
}
```

#### 赋值

```
 Provider.of<CounterProvider>(context, listen: false).addCount()
```

####  取值

```
context.watch<CounterProvider>().count
```

### 通知

小编之前在做Android开发，就用到了这个通知。后来做了Flutter开发一年来头了, 借鉴其思想，创下了这个通知

先说说通知原理：

我们知道EventBus有一个action事件和一个可以传递的数据对象。在页面初始化生命周期中注册通知，在页面销毁生命周期中销毁该通知。在需要发送通知 刷新数据地方， 调用发送通知 ，一个Action 对应发送到哪个通知，通知数据是一个泛型的Object, 可以发送字符串，对象，数组等任何数据

####  通知管理类

在这个类中提供几个方法

1.注册通知

2.销毁通知

3.发送通知

```
///这是一个例子
///这个在initState() 注册   <> 里的类型 要跟 发送的数据类型对应  可以是String int bool  还有model list
///    IUpdateViewManager.instance.registerIUPdateView(UpdateView(NoticeAction.action1,
///      IUpdateView<List<String>>(
///         callback: (List<String> msg) {
///           print(msg);
///            }
///     )));、
///发送通知  注意 这里可以发送任何类型的数据 因为范型
///IUpdateViewManager.instance.notifyIUpdateView(NoticeAction.action1, ['xx', 'vvv']);
///在dispose中 取消注册  注意： 有注册就有取消  这是对应的 否则会出现功能不正常请客
///IUpdateViewManager.instance.unRegistIUpdateView(NoticeAction.action1);
class IUpdateViewManager{
  List<UpdateView> updateViews = [];

  // 工厂模式
  factory IUpdateViewManager() =>_getInstance();
  static IUpdateViewManager get instance => _getInstance();
  static IUpdateViewManager _instance;
  IUpdateViewManager._internal() {
    // 初始化
  }
  static IUpdateViewManager _getInstance() {
    _instance ??= IUpdateViewManager._internal();
    return _instance;
  }
  ///注册通知 在initstatus 注册
  void registerIUPdateView(UpdateView updateView) {
      ///在数组中不能存在多个相同的action
    updateViews.insert(0, updateView);
  }
  ///发送通知  在业务场景需要的地方 调用这个方法
  void notifyIUpdateView <T>(String action, T t) {
    if (updateViews != null && updateViews.isNotEmpty) {
      for (var item in updateViews) {
        if (item.action == action) {
          item.iUpdateView.updateView(t);
          break;
        }
      }
    }
  }
  ///通知解绑  在dispose方法中解绑 注意 有注册 就有解绑 这是一定必须的
  void unRegistIUpdateView(String action) {
    if (updateViews != null && updateViews.isNotEmpty) {
      updateViews.remove(UpdateView(action, null));
    }
  }
}
///这个类是时间action  用到这个类的通知的action 在这里定义常量
class NoticeAction {
  static const String action1 = 'action1';
  static const String action2 = 'action2';




}
```

其次，通知类如下

```
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
```

```
class IUpdateView <T>{
  Function(T msg) callback;
  void updateView (T t) {
    if (callback != null) {
      callback(t);
    }
  }

  IUpdateView({@required this.callback});
}
```

#### 注册通知

这个在initState() 注册   <> 里的类型 要跟 发送的数据类型对应  可以是String int bool  还有model list

```
   IUpdateViewManager.instance.registerIUPdateView(UpdateView(NoticeAction.action1,
      IUpdateView<List<String>>(
         callback: (List<String> msg) {
          print(msg);
            }
     )));、
```

####  发送通知

```
IUpdateViewManager.instance.notifyIUpdateView(NoticeAction.action1, ['xx', 'vvv']);
```

####  销毁通知

在dispose中 取消注册  注意： 有注册就有取消  这是对应的 否则会出现功能不正常

```
IUpdateViewManager.instance.unRegistIUpdateView(NoticeAction.action1);
```

### 架构篇

小编先说说搭建项目的总体思想,

1.  我们知道每一个页面刚进去的时候都会有一个loading,因此小编用一个widget的基类，所有的页面都会继承这个基类。在这个基类中提供了Appbar的方法，加载试图显示和隐藏，加载失败重试，网络请求的方法，另外还有个buildBody方法，所有继承该基类的widget都必须重写这个方法，**详见BasePage**

2. 网络: 本文采用Dio，并添加了拦截器，可在拦截器中打印请求信息，有个HttpManager管理单例的dio实例，并添加了Alice网络查看器，方便测试人员查看请求信息。HttpRequest里有个请求方法， 可定义请求方式，传递方式，失败回调，成功回调。并在回调中返回ResultData（这是一个返回的数据结构封装类）

3. 对于埋点上报，新增了一个GLObserver路由观察者，在这里可以进行简单的用户行为进行捕获

4. 错误日志上报  详见main.dart

5. 由于复杂的页面交互，那么通知也是少不了的，一个页面的某个行为会影响上个页面的展现内容或者刷新数据，那么 这里小编定义了2中方式：1.Provider 2.IupdateViewManager 大家可以任选其一即可

6. 基于SmartRefresher刷新封装的CustomerSmartRefresh 

   最后,代码已上传github , 欢迎下载阅读

   [https://github.com/zhengxiangke/ProjectConstruction](https://github.com/zhengxiangke/ProjectConstruction)








