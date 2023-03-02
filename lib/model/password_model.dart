class Password {
  final String id;
  final String password;

  Password({
    required this.id,
    required this.password,
  });

  factory Password.fromJson(Map<String, dynamic> json) {
    return Password(
      id: json['id'] as String,
      password: json['password'] as String,
    );
  }
}
