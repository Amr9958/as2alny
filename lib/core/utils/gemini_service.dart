import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../constant.dart';

class GeminiService {
  final String apiKey = Platform.environment[kApiKey]!;
  static final GenerativeModel model = GenerativeModel(
    model: kGeminiV,
    apiKey: Platform.environment[kApiKey]!,
  );

  static Future<String?> getGeminiResponse(String message) async {
    final content = [Content.text(message)];

    try {
      final response = await model.generateContent(content);
      print('the response is ' + '${response.text}');
      return response.text;
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }
}
