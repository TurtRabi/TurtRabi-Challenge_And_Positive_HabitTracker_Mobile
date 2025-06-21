class UserDto {
  final String id;
  final String email;
  final String username;
  final String? phone;
  final List<String> roles;

  UserDto({
    required this.id,
    required this.email,
    required this.username,
    this.phone,
    required this.roles,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
}
