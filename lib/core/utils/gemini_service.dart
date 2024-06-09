import 'dart:async';
import 'dart:developer';

import 'package:as2lny_app/core/constant.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static final model = GenerativeModel(
    model: kGeminiV,
    apiKey: kApiKey,
  );
  static Future<String?> getGeminiResponse(String message) async {
    final content = [Content.text(message)];

    try {
      final response = await model.generateContent(content);

      return response.text;
    } catch (e) {
      log('خطأ: $e');
    }

    return null;
  }
}
