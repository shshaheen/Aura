import 'package:google_generative_ai/google_generative_ai.dart';
// import '../secrets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class GeminiService {
  static String apiKey =  dotenv.env['GEMINI_SERVICE_KEY'] ?? ''; // Replace with your key

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: apiKey,
  );


  Future<String> getResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? "No response from AI";
    } catch (e) {
      return "Error: $e";
    }
  }
}
