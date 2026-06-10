import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../api_client.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('${ApiClient.baseUrl.replaceAll('/api/auth', '/api/categories')}'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw e;
    }
  }
}
