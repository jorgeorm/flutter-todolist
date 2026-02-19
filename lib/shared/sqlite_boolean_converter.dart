import 'package:json_annotation/json_annotation.dart';

class SqliteBooleanConverter implements JsonConverter<bool, int> {
  const SqliteBooleanConverter();

  @override
  bool fromJson(int json) {
    return json == 1;
  }

  @override
  int toJson(bool object) {
    return object ? 1 : 0;
  }
}
