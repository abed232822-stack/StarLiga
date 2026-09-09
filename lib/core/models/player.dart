import 'package:starliga/core/models/team.dart';

class Player {
  final int? id;
  final String fullName;
  final String? fatherName;
  final String? middleName;
  final String role;
  final int age;
  final String? image;
  final int? teamId;
  final Team? team;

  Player({
    this.id,
    required this.fullName,
    this.fatherName,
    this.middleName,
    required this.role,
    required this.age,
    this.image,
    this.teamId,
    this.team,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int?,
      fullName: json['full_name'] as String? ?? '',
      fatherName: json['father_name'] as String?,
      middleName: json['midle_name'] as String?,
      role: json['role'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      image: json['image_url'] as String?,
      teamId: json['team_id'] as int?,
      team: json['team'] != null ? Team.fromJson(json['team']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'full_name': fullName,
      'role': role,
      'age': age,
      if (fatherName != null) 'father_name': fatherName,
      if (middleName != null) 'midle_name': middleName,
      if (image != null) 'image_url': image,
      if (teamId != null) 'team_id': teamId,
      if (team != null) 'team': team!.toJson(),
    };
  }
}
