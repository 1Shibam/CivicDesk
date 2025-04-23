class AdminModel {
  final String uid;
  final String name;
  final String email;
  final String department;
  final String post;
  final String profileUrl;
  final String createdAt;
  final bool isActive;

  AdminModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.department,
    required this.post,
    required this.profileUrl,
    required this.createdAt,
    this.isActive = true,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      department: map['department'],
      post: map['post'],
      profileUrl: map['profileUrl'] ?? '',
      createdAt: map['createdAt'],
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'department': department,
      'post': post,
      'profileUrl': profileUrl,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }
}
