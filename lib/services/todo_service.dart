import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// All todo api call will be here
class TodoService {
  static Future<bool> deleteById(String id) async {
    // Delete the item
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodo() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    debugPrint("Status code: ${response.statusCode}");
    debugPrint("Status body: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }
}