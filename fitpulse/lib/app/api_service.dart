import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../app/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> scanFood(XFile image) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/scan-food');
    final request = http.MultipartRequest('POST', uri);
    final bytes = await image.readAsBytes();
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'food.${image.mimeType?.split('/').last ?? 'jpg'}'));
    final response = await request.send();
    final body = await response.stream.bytesToString();
    return jsonDecode(body) as Map<String, dynamic>;
  }

  static Future<List<Map<String, dynamic>>> searchFood(String query, {int pageSize = 10}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/search-food').replace(queryParameters: {
      'query': query,
      'page_size': pageSize.toString(),
    });
    final response = await http.get(uri);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['results'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  static Future<String> uploadPhoto(XFile image) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/dywystvlf/image/upload');
    final request = http.MultipartRequest('POST', uri);
    final bytes = await image.readAsBytes();
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'photo.${image.mimeType?.split('/').last ?? 'jpg'}'));
    request.fields['upload_preset'] = 'Fitpu1se';
    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    return data['secure_url'] as String;
  }
}
