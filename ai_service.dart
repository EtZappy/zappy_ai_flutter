
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  AIService._();
  static final instance = AIService._();

  static const _apiKey = 'DEMO_OPENROUTER_KEY'; // change in Settings

  Future<String> getReply(String prompt) async {
    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": prompt}
      ]
    };
    final res = await http.post(uri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['choices'][0]['message']['content'];
    }
    return 'Sorry, something went wrong.';
  }
}
