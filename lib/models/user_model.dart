class UserModel {
  final String id;
  final String name;
  final String occupation;
  final String email;
  final String profileUrl;
  final String joinedAt;
  final int age;
  final String gender;
  final int totalComplaints;
  final int pendingComplaints;
  final int resolvedComplaints;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.profileUrl,
      required this.joinedAt,
      required this.age,
      required this.occupation,
      required this.gender,
      required this.totalComplaints,
      required this.pendingComplaints,
      required this.resolvedComplaints});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['user_id'],
        name: json['name'],
        occupation: json['occupation'],
        email: json['email'],
        profileUrl: json['profile_url'],
        joinedAt: json['joined_at'],
        age: json['age'],
        gender: json['gender'],
        totalComplaints: json['total_complaints'],
        pendingComplaints: json['pending_complaints'],
        resolvedComplaints: json['resolved_complaints']);
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'occupation': occupation,
      'email': email,
      'profile_url': profileUrl,
      'joined_at': joinedAt,
      'age': age,
      'gender': gender,
      'total_complaints': totalComplaints,
      'pending_complaints': pendingComplaints,
      'resolved_complaints': resolvedComplaints
    };
  }
}
