import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:learning_managment_system/model/subject_model.dart';

class SubjectApiService {
  final String baseUrl = "https://trogon.info/interview/php/api/subjects.php";

  //
  Future<List<SubjectModel>> getSubjects() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((e) => SubjectModel.fromjson(e as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }
}
