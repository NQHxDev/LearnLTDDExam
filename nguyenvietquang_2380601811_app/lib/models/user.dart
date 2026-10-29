class User {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String role;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'],
      role: json['role'] ?? 'User',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt']),
    );
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
}