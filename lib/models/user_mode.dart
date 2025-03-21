class UserModel {
  final String id;
  final String name;
  final String role;
  final String email;
  final String profileUrl;
  final String joinedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.profileUrl,
    required this.joinedAt
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        role: json['role'],
        email: json['email'],
        profileUrl: json['profile_url'],
        joinedAt: json['joined_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'role': role,
      'email': email,
      'profile_url': profileUrl,
      'joined_at': joinedAt
    };
  }
}
