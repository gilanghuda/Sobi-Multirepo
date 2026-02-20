import 'package:sobi/features/domain/entities/education_entity.dart';

class EducationModel {
  final String id;
  final String title;
  final String subtitle;
  final String videoUrl;
  final String duration;
  final String author;
  final String description;
  final DateTime createdAt;

  EducationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.videoUrl,
    required this.duration,
    required this.author,
    required this.description,
    required this.createdAt,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      videoUrl: json['video_url'],
      duration: json['duration'],
      author: json['author'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  EducationEntity toEntity() {
    return EducationEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      videoUrl: videoUrl,
      duration: duration,
      author: author,
      description: description,
      createdAt: createdAt,
    );
  }
}
