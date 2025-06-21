import 'package:tracking_positive_mobile/core/Dto/UserDto.dart';

class RedisDto{
  final String key;
  final String Value;

  RedisDto({required this.key, required this.Value});
  factory RedisDto.fromJson(Map<String, dynamic> json) {
    return RedisDto(
      key: json['key'],
      Value: json['Value'],
    );
  }
}