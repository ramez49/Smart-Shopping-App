import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';

class GeminiService {
  // API key loaded securely from .env file
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  /// Validates that the API key is configured
  bool get isConfigured => _apiKey.isNotEmpty && _apiKey != 'YOUR_API_KEY';

  Future<String> chatWithGemini(String userMessage, List<Product> products) async {
    // Check if API key is configured
    if (!isConfigured) {
      return "Error: Gemini API key is not configured. Please add your API key to the .env file.";
    }

    final productContext = products.map((p) => """
- Name: ${p.name}
  Price: \$${p.price}
  Category: ${p.category}
  Description: ${p.description}
""").join("\n");
    
    final systemInstruction = """
You are an expert sales assistant for our mobile app store. 
You have detailed access to the following product catalog:

$productContext

Your goal is to help users find the perfect product. 
- When asked about prices, be specific.
- When asked for recommendations (e.g., "smart watches"), suggest items from the list based on their descriptions.
- If a user asks for something not in the list, politely apologize and suggest similar available items if possible.
- Be friendly, concise, and helpful.
""";

    try {
      debugPrint('[GeminiService] Sending request to Gemini API...');
      
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "$systemInstruction\n\nUser: $userMessage"}
              ]
            }
          ]
        }),
      ).timeout(const Duration(seconds: 15));

      debugPrint('[GeminiService] Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty && 
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          // Check for finishReason if no content
          if (data['candidates'] != null && data['candidates'].isNotEmpty) {
             final finishReason = data['candidates'][0]['finishReason'];
             return "I couldn't generate a response. (Reason: $finishReason)";
          }
          return "No response content generated.";
        }
      } else if (response.statusCode == 400) {
        debugPrint('[GeminiService] Bad Request: ${response.body}');
        return "Invalid request. Please check your message and try again.";
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint('[GeminiService] Auth Error: ${response.body}');
        return "API Key is invalid or expired. Please check your Gemini API key.";
      } else if (response.statusCode == 429) {
        return "Too many requests. Please wait a moment and try again.";
      } else if (response.statusCode >= 500) {
        return "Gemini server is temporarily unavailable. Please try again later.";
      } else {
        debugPrint('[GeminiService] Unexpected Error: ${response.statusCode} - ${response.body}');
        return "Unexpected error occurred (Code: ${response.statusCode}). Please try again.";
      }
    } on http.ClientException catch (e) {
      debugPrint('[GeminiService] Network Error: $e');
      return "Network error. Please check your internet connection.";
    } catch (e) {
      debugPrint('[GeminiService] Unexpected Error: $e');
      return "Connection failed. Please check your internet and try again.";
    }
  }
}
