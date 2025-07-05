class SubjectModel {
  final int subjectId;
  final String subjectTitle;
  final String subjectDescription;
  final String subjectImageUrl;

  SubjectModel({
    required this.subjectId,
    required this.subjectTitle,
    required this.subjectDescription,
    required this.subjectImageUrl,
  });

  //json convert
  factory SubjectModel.fromjson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['id'],
      subjectTitle: json['title'],
      subjectDescription: json['description'],
      subjectImageUrl: json['image'],
    );
  }
}
