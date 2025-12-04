import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000'; // Android emulator example

  Future<Uint8List?> fetchImage() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/generate'));
      if (response.statusCode == 200) return response.bodyBytes;
      print('API error: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }
}
