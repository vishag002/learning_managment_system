import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning_managment_system/model/modules_content_model.dart';

class ModulesApiService {
  final String baseUrl =
      "https://trogon.info/interview/php/api/videos.php?module_id=1";

  Future<List<ModulesViewModel>> getModulesList() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((e) => ModulesViewModel.fromjson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load modules: ${response.statusCode}');
    }
  }
}
