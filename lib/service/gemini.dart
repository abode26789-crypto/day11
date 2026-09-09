import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class GeminiAPI {
  final apiUrl = dotenv.get('API_URL');
  final retries = dotenv.getInt('MAX_RETRIES', fallback: 1);
  final debug = dotenv.getBool('DEBUG', fallback: false);
  final String _apiKey;

  GeminiAPI({String? apiKey})
    : _apiKey = apiKey ?? dotenv.get('api-key');

  

  Future<String> sendRequest(String prompt) async {
    if (_apiKey.isEmpty) {
      throw StateError(
        'Missing Gemini API key. Set the GEMINI_API_KEY environment variable or pass apiKey to GeminiAPI().',
      );
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Request failed: ${response.statusCode} ${response.body}',
      );
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = responseBody['candidates'] as List<dynamic>? ?? const [];
    if (candidates.isEmpty) {
      return 'No answer returned.';
    }

    final candidate = candidates.first as Map<String, dynamic>;
    final content = candidate['content'] as Map<String, dynamic>? ?? const {};
    final parts = content['parts'] as List<dynamic>? ?? const [];

    return parts
        .whereType<Map<String, dynamic>>()
        .map((part) => part['text']?.toString() ?? '')
        .join()
        .trim();
  }
}
