class AdminModel {
  final String uid;
  final String name;
  final String email;
  final String department;
  final String post;
  final String profileUrl;
  final String createdAt;

  AdminModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.department,
    required this.post,
    required this.profileUrl,
    required this.createdAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      department: map['department'],
      post: map['post'],
      profileUrl: map['profileUrl'] ?? '',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'department': department,
      'post': post,
      'profileUrl': profileUrl,
      'createdAt': createdAt
    };
  }
}
