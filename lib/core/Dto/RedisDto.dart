class RedisDto {
  final String key;
  final String value;

  RedisDto({required this.key, required this.value});

  factory RedisDto.fromJson(Map<String, dynamic> json) {
    return RedisDto(
      key: json['key'],
      value: json['value'],
    );
  }
}
