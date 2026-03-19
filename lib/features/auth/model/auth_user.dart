class AuthUserStats {
  const AuthUserStats({
    required this.campaignsCreated,
    required this.assignedTasks,
    required this.badges,
  });

  final int campaignsCreated;
  final int assignedTasks;
  final int badges;

  factory AuthUserStats.fromJson(Map<String, dynamic>? json) {
    return AuthUserStats(
      campaignsCreated: _parseInt(json?['campaignsCreated']),
      assignedTasks: _parseInt(json?['assignedTasks']),
      badges: _parseInt(json?['badges']),
    );
  }
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.nationalId,
    required this.email,
    required this.phone,
    required this.status,
    required this.totalHours,
    required this.points,
    required this.stats,
    this.gender,
    this.city,
    this.dateOfBirth,
    this.joinDate,
    this.createdAt,
  });

  final int id;
  final String fullName;
  final String nationalId;
  final String email;
  final String phone;
  final String status;
  final int totalHours;
  final int points;
  final AuthUserStats stats;
  final String? gender;
  final String? city;
  final DateTime? dateOfBirth;
  final DateTime? joinDate;
  final DateTime? createdAt;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: _parseInt(json['id']),
      fullName: json['fullName']?.toString() ?? '',
      nationalId: json['nationalId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalHours: _parseInt(json['totalHours']),
      points: _parseInt(json['points']),
      stats: AuthUserStats.fromJson(json['stats'] as Map<String, dynamic>?),
      gender: _parseString(json['gender']),
      city: _parseString(json['city']),
      dateOfBirth: _parseDate(json['dateOfBirth']),
      joinDate: _parseDate(json['joinDate']),
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value);
  }

  return null;
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String? _parseString(dynamic value) {
  final normalizedValue = value?.toString().trim();

  if (normalizedValue == null || normalizedValue.isEmpty) {
    return null;
  }

  return normalizedValue;
}
