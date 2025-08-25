// Lokasi: lib/services/gemini_service.dart

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class GeminiService {
  static Future<String> getResponse(String userPrompt, Locale locale) async {
    try {
      // 1. Ambil API Key dari Firebase Remote Config
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
      final apiKey = remoteConfig.getString('gemini_api_key');

      if (apiKey.isEmpty) {
        return AppStrings.get(locale, 'geminiErrorAPIKey');
      }

      // 2. Lanjutkan dengan logika yang sudah ada
      final model =
          GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);

      final fullPrompt = '''
        You are a friendly and helpful virtual assistant for an e-commerce app named "RUANG" that sells premium furniture. 
        Your name is Rara. Your goal is to help users find furniture. 
        Keep your answers concise and relevant to furniture.
        
        User's question: "$userPrompt"
      ''';

      final content = [Content.text(fullPrompt)];
      final response = await model.generateContent(content);

      return response.text ?? AppStrings.get(locale, 'geminiErrorGeneric');
    } catch (e) {
      developer.log("Error communicating with Gemini API: $e");
      return AppStrings.get(locale, 'geminiErrorConnection');
    }
  }
}
