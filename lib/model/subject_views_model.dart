class SubjectsViewModel {
  final int moduleId;
  final String subjectsModuleTitle;
  final String subjectsModuleDescription;

  SubjectsViewModel({
    required this.moduleId,
    required this.subjectsModuleTitle,
    required this.subjectsModuleDescription,
  });

  //json convert
  factory SubjectsViewModel.fromjson(Map<String, dynamic> json) {
    return SubjectsViewModel(
      moduleId: json['id'],
      subjectsModuleTitle: json['title'],
      subjectsModuleDescription: json['description'],
    );
  }
}
