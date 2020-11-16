//  Created by zhengxiangke
//  des:
//
import 'package:flutter/cupertino.dart';

class Item extends StatefulWidget {
  bool isd;

  Item(this.isd);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          widget.isd = !widget.isd;
        });
      },
      child: Container(
        height: 50,
      ),
    );
  }
}
