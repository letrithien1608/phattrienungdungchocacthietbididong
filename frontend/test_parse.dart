import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/models/product.dart';

void main() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:8080/api/products'));
    final List<dynamic> jsonList = jsonDecode(response.body);
    for (var json in jsonList) {
      try {
        Product.fromJson(json);
      } catch (e) {
        print("Error parsing product: ${json['id']} - $e");
        return;
      }
    }
    print("Parsed all ${jsonList.length} products successfully.");
  } catch (e) {
    print("Failed to fetch products: $e");
  }
}
