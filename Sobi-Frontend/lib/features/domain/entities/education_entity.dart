class EducationEntity {
  final String id;
  final String title;
  final String subtitle;
  final String videoUrl;
  final String duration;
  final String author;
  final String description;
  final DateTime createdAt;

  EducationEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.videoUrl,
    required this.duration,
    required this.author,
    required this.description,
    required this.createdAt,
  });
}
