import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning_managment_system/model/subject_views_model.dart';

class SubjectViewApiService {
  final String baseUrl =
      "https://trogon.info/interview/php/api/modules.php?subject_id=1";

  Future<List<SubjectsViewModel>> getSubjectModules() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((e) => SubjectsViewModel.fromjson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load modules: ${response.statusCode}');
    }
  }
}
