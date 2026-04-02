class User {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int? ?? 0,
      username: json["username"] as String? ?? '',
      email: json["email"] as String? ?? '',
      firstName: json["first_name"] as String?,
      lastName: json["last_name"] as String?,
    );
  }

  String get displayName {
    if (firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName != null && firstName!.isNotEmpty) {
      return firstName!;
    } else if (lastName != null && lastName!.isNotEmpty) {
      return lastName!;
    } else {
      return username;
    }
  }
}
