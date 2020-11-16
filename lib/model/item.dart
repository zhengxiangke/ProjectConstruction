/// id : 38
/// taskName : "李明喆医生"
/// outCount : 2.0000
/// dateCount : null
/// type : 4
/// money : 10.0000
/// imgUrl : null
/// statusName : "待出库"
/// code : null

class Item {
  int _id;
  String _taskName;
  double _outCount;
  dynamic _dateCount;
  int _type;
  double _money;
  dynamic _imgUrl;
  String _statusName;
  dynamic _code;

  int get id => _id;
  String get taskName => _taskName;
  double get outCount => _outCount;
  dynamic get dateCount => _dateCount;
  int get type => _type;
  double get money => _money;
  dynamic get imgUrl => _imgUrl;
  String get statusName => _statusName;
  dynamic get code => _code;

  Item({
      int id, 
      String taskName, 
      double outCount, 
      dynamic dateCount, 
      int type, 
      double money, 
      dynamic imgUrl, 
      String statusName, 
      dynamic code}){
    _id = id;
    _taskName = taskName;
    _outCount = outCount;
    _dateCount = dateCount;
    _type = type;
    _money = money;
    _imgUrl = imgUrl;
    _statusName = statusName;
    _code = code;
}

  Item.fromJson(dynamic json) {
    _id = json["id"];
    _taskName = json["taskName"];
    _outCount = json["outCount"];
    _dateCount = json["dateCount"];
    _type = json["type"];
    _money = json["money"];
    _imgUrl = json["imgUrl"];
    _statusName = json["statusName"];
    _code = json["code"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["taskName"] = _taskName;
    map["outCount"] = _outCount;
    map["dateCount"] = _dateCount;
    map["type"] = _type;
    map["money"] = _money;
    map["imgUrl"] = _imgUrl;
    map["statusName"] = _statusName;
    map["code"] = _code;
    return map;
  }

}