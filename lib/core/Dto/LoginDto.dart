class LoginDto {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String userId;

  LoginDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.userId
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
      userId: json['idUser']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'idUser':userId
    };
  }
}
