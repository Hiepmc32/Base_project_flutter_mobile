import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

bool isNullOrEmpty(dynamic x) {
  assert(x == null || x is String || x is List || x is Map || x is Set);

  if (x == null) {
    return true;
  }

  if (x is String) {
    return x.trim().isEmpty;
  }

  if (x is List) {
    return x.isEmpty;
  }

  if (x is Map) {
    return x.isEmpty;
  }

  if (x is Set) {
    return x.isEmpty;
  }

  return true;
}

bool isNotNullOrEmpty(dynamic x) {
  assert(x == null || x is String || x is List || x is Map || x is Set);

  if (x == null) {
    return false;
  }

  if (x is String) {
    return x.isNotEmpty;
  }

  if (x is List) {
    return x.isNotEmpty;
  }

  if (x is Map) {
    return x.isNotEmpty;
  }

  if (x is Set) {
    return x.isNotEmpty;
  }

  return false;
}

bool isNull(dynamic x) {
  return x == null;
}

bool isNotNull(dynamic x) {
  return x != null;
}

bool rejectIfEqual(List<bool> x) {
  for (final bool xx in x) {
    if (xx) {
      return false;
    }
  }

  return true;
}

// "03:21:00" -> ngày hiện tại + giờ input . flutter không hỗ trợ HHmmss nhưng vẫn có API trả ra thì dùng hàm t2
DateTime getCurrentDateTimeWithCustomTime(
  String? timeString, {
  DateTime? timeNow,
  String type = 'HH:mm:ss',
}) {
  try {
    final DateTime now = timeNow ?? DateTime.now();
    final DateTime time = DateFormat(type).parse(timeString ?? '');
    return DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
  } catch (e) {
    return timeNow ?? DateTime.now();
  }
}

// "233506" -> ngày hiện tại + giờ input
DateTime getCurrentDateTimeWithCustomTime2(
  String timeString, {
  DateTime? timeNow,
}) {
  try {
    final DateTime now = timeNow ?? DateTime.now();
    // Format Giờ về dạng String 6 số (TH: lenght<6)
    switch (timeString.length) {
      case 1:
        timeString = '00000$timeString';
        break;
      case 2:
        timeString = '0000$timeString';
        break;
      case 3:
        timeString = '000$timeString';
        break;
      case 4:
        timeString = '00$timeString';
        break;
      case 5:
        timeString = '0$timeString';
        break;
    }
    final int hour = int.parse(timeString.substring(0, 2));
    final int minute = int.parse(timeString.substring(2, 4));
    final int second = int.parse(timeString.substring(4, 6));
    return DateTime(now.year, now.month, now.day, hour, minute, second);
  } catch (e) {
    return timeNow ?? DateTime.now();
  }
}

int sortCompare(dynamic a, dynamic b) {
  if (a is String && b is String) {
    return compareNatural(a, b);
  } else if (a is num && b is num) {
    return a.compareTo(b);
  } else if (a is String) {
    return -1;
  } else {
    return 1;
  }
}

Map<String, dynamic> _runtimeTypeMap(Map<String, dynamic> inputMap) {
  Map<String, dynamic> outputMap = {};
  inputMap.forEach((key, value) {
    if (value is List) {
      List<dynamic> outputList = [];
      for (dynamic element in value) {
        outputList.add(element.runtimeType);
      }
      outputMap[key] = outputList;
    } else if (value is Map) {
      outputMap[key] = _runtimeTypeMap(inputMap);
    } else {
      outputMap[key] = value.runtimeType;
    }
  });
  return outputMap;
}

void runtimeTypeMap(Map<String, dynamic> inputMap) {
  debugPrint('====>inputMap$inputMap');
  debugPrint('====>outputMap${_runtimeTypeMap(inputMap)}');
}

void runtimeTypeList(List<dynamic> inputList) {
  List<dynamic> outputList = [];
  for (dynamic element in inputList) {
    outputList.add(element.runtimeType);
  }
  debugPrint('====>inputList$inputList');
  debugPrint('====>outputList$outputList');
}
