class AppUser {
  //basic user info
  final String uid;
  final String name;
  final String gender;
  final String dob;
  final String occupation;

  final String email;
  final String profileImage;
  final DateTime joinedAt;

  //ban info
  final bool isBanned;
  final String banReason;
  final DateTime? banUntil;
  final int warnings;
  final DateTime? lastWarningAt;

  //verification info
  final bool isVerified;
  final int reportCount;
  final int resolvedReports;
  final int reputationScore;

  //toxicity info
  final double toxicityScore;
  final int flaggedMessages;
  final DateTime? lastFlaggedAt;

  //login info
  final DateTime lastLogin;
  final int totalComplaints;
  final String? deviceId;

  //ai info (chat)
  final int aiInteractions;
  final String lastAiPrompt;
  final bool mutedInChat;
//constructor
  AppUser({
    required this.uid,
    required this.name,
    required this.gender,
    required this.dob,
    required this.occupation,
    required this.email,
    required this.profileImage,
    required this.joinedAt,
    this.isBanned = false,
    this.banReason = '',
    this.banUntil,
    this.warnings = 0,
    this.lastWarningAt,
    this.isVerified = false,
    this.reportCount = 0,
    this.resolvedReports = 0,
    this.reputationScore = 100,
    this.toxicityScore = 0.0,
    this.flaggedMessages = 0,
    this.lastFlaggedAt,
    required this.lastLogin,
    this.totalComplaints = 0,
    this.deviceId,
    this.aiInteractions = 0,
    this.lastAiPrompt = '',
    this.mutedInChat = false,
  });

  //factory constructor from json
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      gender: json['gender'],
      dob: json['dob'],
      occupation: json['occupation'],
      email: json['email'],
      profileImage: json['profileImage'],
      joinedAt: DateTime.parse(json['joinedAt']),
      isBanned: json['isBanned'] ?? false,
      banReason: json['banReason'] ?? '',
      banUntil:
          json['banUntil'] != null ? DateTime.parse(json['banUntil']) : null,
      warnings: json['warnings'] ?? 0,
      lastWarningAt: json['lastWarningAt'] != null
          ? DateTime.parse(json['lastWarningAt'])
          : null,
      isVerified: json['isVerified'] ?? false,
      reportCount: json['reportCount'] ?? 0,
      resolvedReports: json['resolvedReports'] ?? 0,
      reputationScore: json['reputationScore'] ?? 100,
      toxicityScore: json['toxicityScore']?.toDouble() ?? 0.0,
      flaggedMessages: json['flaggedMessages'] ?? 0,
      lastFlaggedAt: json['lastFlaggedAt'] != null
          ? DateTime.parse(json['lastFlaggedAt'])
          : null,
      lastLogin: DateTime.parse(json['lastLogin']),
      totalComplaints: json['totalComplaints'] ?? 0,
      deviceId: json['deviceId'],
      aiInteractions: json['aiInteractions'] ?? 0,
      lastAiPrompt: json['lastAiPrompt'] ?? '',
      mutedInChat: json['mutedInChat'] ?? false,
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'occupation': occupation,
      'dob': dob,
      'email': email,
      'profileImage': profileImage,
      'joinedAt': joinedAt.toIso8601String(),
      'isBanned': isBanned,
      'banReason': banReason,
      'banUntil': banUntil?.toIso8601String(),
      'warnings': warnings,
      'lastWarningAt': lastWarningAt?.toIso8601String(),
      'isVerified': isVerified,
      'reportCount': reportCount,
      'resolvedReports': resolvedReports,
      'reputationScore': reputationScore,
      'toxicityScore': toxicityScore,
      'flaggedMessages': flaggedMessages,
      'lastFlaggedAt': lastFlaggedAt?.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'totalComplaints': totalComplaints,
      'deviceId': deviceId,
      'aiInteractions': aiInteractions,
      'lastAiPrompt': lastAiPrompt,
      'mutedInChat': mutedInChat,
    };
  }
}
