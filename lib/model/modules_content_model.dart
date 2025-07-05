class ModulesViewModel {
  final int moduleId;
  final String moduleTitle;
  final String moduleDescription;
  final String videoType;
  final String videoUrl;

  ModulesViewModel({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.videoType,
    required this.videoUrl,
  });

  //json convert
  factory ModulesViewModel.fromjson(Map<String, dynamic> json) {
    return ModulesViewModel(
      moduleId: json['id'],
      moduleTitle: json['title'],
      moduleDescription: json['description'],
      videoType: json['video_type'],
      videoUrl: json['video_url'],
    );
  }
}
