import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/CounterProvider.dart';
import 'package:flutter_app/utils/widget/my_appBar.dart';
import 'package:provider/provider.dart';

///  Created by zhengxiangke
///  des:
class ProviderDemo extends StatefulWidget {
  @override
  _ProviderDemoState createState() => _ProviderDemoState();
}

class _ProviderDemoState extends State<ProviderDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Providerdemo ${context.watch<CounterProvider>().count}',),
      body: Container(
        child: InkWell(
          child: Text('点击加1'),
          onTap: () {
            Provider.of<CounterProvider>(context, listen: false).addCount();
          },
        ),
      ),
    );
  }
}
