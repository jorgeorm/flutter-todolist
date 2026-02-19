import 'package:json_annotation/json_annotation.dart';

class MillisecondsConverter implements JsonConverter<DateTime?, int?> {
  const MillisecondsConverter();

  @override
  DateTime? fromJson(int? value) {
    if (value != null) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    return null;
  }

  @override
  int? toJson(DateTime? object) {
    if (object != null) {
      return object.millisecondsSinceEpoch;
    }

    return null;
  }
}

class MillisecondsNonNullConverter implements JsonConverter<DateTime, int> {
  const MillisecondsNonNullConverter();

  @override
  DateTime fromJson(int value) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  @override
  int toJson(DateTime object) {
    return object.millisecondsSinceEpoch;
  }
}
