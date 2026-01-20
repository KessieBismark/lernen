// groq_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lernen/utils/helpers.dart';

import 'prompt.dart';

class GroqClient {
  final String apiKey;
  final String baseUrl = 'https://api.groq.com/openai/v1';

  // Available models: mixtral-8x7b-32768, gemma2-9b-it, llama-3.1-8b-instant, llama-3.1-70b-versatile

  GroqClient({
    required this.apiKey,
  });

  Future<Map<String, dynamic>> sendPrompt({
    required String prompt,
    double temperature = 0.7,
    int maxTokens = 4000,
    double topP = 1.0,
  }) async {
    try {
      // Create the base request body
      var requestBody = {
        'model': Utils.selectedAIModel,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': temperature,
        'max_tokens': maxTokens,
        'top_p': topP,
        'stream': false,
      };

      // --- Add the parameter to disable "thinking" ---
      // Option A: For reasoning models like 'qwen/qwen3-32b', use 'reasoning_format'
      if (Utils.selectedAIModel.startsWith('qwen/') ||
          Utils.selectedAIModel.contains('deepseek-r1') ||
          Utils.selectedAIModel.contains('gpt-oss')) {
        // 'hidden' will return only the final answer
        requestBody['reasoning_format'] = 'hidden';
      }
      // Option B: Alternatively, for Qwen models, you can disable reasoning entirely
      // if (Utils.selectedAIModel == 'qwen/qwen3-32b') {
      //   requestBody['reasoning_effort'] = 'none';
      // }

      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody), // Encode the updated body
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String content = data['choices'][0]['message']['content'];
        final cleanedData = _cleanResponse(content);
        // Try to parse as JSON if it looks like JSON
        try {
          return jsonDecode(cleanedData);
        } catch (e) {
          // If not JSON, return as text
          return {'text_response': content};
        }
      } else {
        throw Exception(
            'Groq API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to send request: $e');
    }
  }

  dynamic _cleanResponse(dynamic response) {
    if (response is String) {
      // Remove markdown code blocks
      String cleaned = response.trim();

      // Handle ```json or ``` blocks
      if (cleaned.startsWith('```')) {
        // Find the first newline after ```
        final firstNewline = cleaned.indexOf('\n');
        if (firstNewline != -1) {
          cleaned = cleaned.substring(firstNewline).trim();
        } else {
          cleaned = cleaned.substring(3).trim();
        }

        // Remove trailing ```
        if (cleaned.endsWith('```')) {
          cleaned = cleaned.substring(0, cleaned.length - 3).trim();
        }
      }

      return cleaned;
    }
    return response;
  }
  // Future<Map<String, dynamic>> sendPrompt({
  //   required String prompt,
  //   double temperature = 0.7,
  //   int maxTokens = 4000,
  //   double topP = 1.0,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/chat/completions'),
  //       headers: {
  //         'Authorization': 'Bearer $apiKey',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'model': Utils.selectedAIModel,
  //         'messages': [
  //           {
  //             'role': 'user',
  //             'content': prompt,
  //           }
  //         ],
  //         'temperature': temperature,
  //         'max_tokens': maxTokens,
  //         'top_p': topP,
  //         'stream': false,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       final String content = data['choices'][0]['message']['content'];
  //       print(jsonDecode(content));
  //       // Try to parse as JSON if it looks like JSON
  //       try {
  //         return jsonDecode(content);
  //       } catch (e) {
  //         // If not JSON, return as text
  //         return {'text_response': content};
  //       }
  //     } else {
  //       throw Exception(
  //           'Groq API Error: ${response.statusCode} - ${response.body}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to send request: $e');
  //   }
  // }

  // Convenience methods for each prompt type

  Future<Map<String, dynamic>> getVerbConjugation(String verb) async {
    final prompt = VerbPrompt(verb).prompt;
    return await sendPrompt(prompt: prompt);
  }

  Future<Map<String, dynamic>> getConversation(String topic) async {
    final prompt = ConversationPrompt(topic).prompt;
    return await sendPrompt(prompt: prompt, maxTokens: 8000);
  }

  Future<Map<String, dynamic>> continueConversation({
    required String newInput,
    required String chatHistory,
  }) async {
    final prompt = ConversationContinuationPrompt(newInput, chatHistory).prompt;
    return await sendPrompt(prompt: prompt, maxTokens: 8000);
  }

  Future<Map<String, dynamic>> getChatTitle(String query) async {
    final prompt = GetTitlePrompt(query).prompt;
    return await sendPrompt(prompt: prompt, maxTokens: 200);
  }

  Future<Map<String, dynamic>> getGeneralSearch({
    required String query,
    required String chatHistory,
  }) async {
    final prompt = GeneralSearchPrompt(query, chatHistory).prompt;
    return await sendPrompt(prompt: prompt, maxTokens: 6000);
  }

  Future<Map<String, dynamic>> getGermanQuiz(String level) async {
    final prompt = GermanQuizPrompt(level).prompt;
    return await sendPrompt(prompt: prompt, maxTokens: 6000, temperature: 0.3);
  }
}

// Response parsing utilities
class ResponseParser {
  // Parse verb conjugation response
  static Map<String, dynamic> parseVerbResponse(Map<String, dynamic> response) {
    try {
      // If response contains 'text_response', it's not JSON
      if (response.containsKey('text_response')) {
        // Try to extract JSON from text
        final text = response['text_response'];
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);
        if (jsonMatch != null) {
          return jsonDecode(jsonMatch.group(0)!);
        }
        return {'error': 'Could not parse JSON from response', 'raw': text};
      }
      return response;
    } catch (e) {
      return {'error': 'Parsing failed: $e', 'raw': response.toString()};
    }
  }

  // Parse conversation response
  static List<Map<String, dynamic>> parseConversationResponse(
      Map<String, dynamic> response) {
    try {
      if (response.containsKey('conversation')) {
        return List<Map<String, dynamic>>.from(response['conversation']);
      } else if (response.containsKey('text_response')) {
        final text = response['text_response'];
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);
        if (jsonMatch != null) {
          final parsed = jsonDecode(jsonMatch.group(0)!);
          if (parsed.containsKey('conversation')) {
            return List<Map<String, dynamic>>.from(parsed['conversation']);
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Parse quiz response
  static List<Map<String, dynamic>> parseQuizResponse(
      Map<String, dynamic> response) {
    try {
      if (response.containsKey('questions')) {
        return List<Map<String, dynamic>>.from(response['questions']);
      } else if (response.containsKey('text_response')) {
        final text = response['text_response'];
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);
        if (jsonMatch != null) {
          final parsed = jsonDecode(jsonMatch.group(0)!);
          if (parsed.containsKey('questions')) {
            return List<Map<String, dynamic>>.from(parsed['questions']);
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

// Example usage with all prompts
void main() async {
  // Replace with your actual Groq API key
  const apiKey = 'your_groq_api_key_here';

  final groq = GroqClient(apiKey: apiKey);

  try {
    print('=== Testing Groq AI Integration ===\n');

    // 1. Test Verb Conjugation
    print('1. Testing Verb Conjugation for "gehen":');
    final verbResponse = await groq.getVerbConjugation('gehen');
    final parsedVerb = ResponseParser.parseVerbResponse(verbResponse);
    print('German Data: ${parsedVerb['german_data'] ?? 'N/A'}');
    print(
        'Past Participle: ${parsedVerb['data_forms']?['past_participle'] ?? 'N/A'}');
    print('---\n');

    // 2. Test Conversation
    print('2. Testing Conversation about "Ordering coffee":');
    final conversationResponse = await groq.getConversation('Ordering coffee');
    final conversation =
        ResponseParser.parseConversationResponse(conversationResponse);
    print('Number of conversation lines: ${conversation.length}');
    if (conversation.isNotEmpty) {
      print('First line (German): ${conversation[0]['german']}');
      print('First line (English): ${conversation[0]['english']}');
    }
    print('---\n');

    // 3. Test Conversation Continuation
    print('3. Testing Conversation Continuation:');
    final chatHistory = '''
    [
      {"speaker": "Customer", "german": "Guten Tag!", "english": "Good day!"},
      {"speaker": "Barista", "german": "Guten Tag! Was darf es sein?", "english": "Good day! What would you like?"}
    ]
    ''';

    final continuationResponse = await groq.continueConversation(
      newInput: 'I would like a cappuccino',
      chatHistory: chatHistory,
    );
    final continuation =
        ResponseParser.parseConversationResponse(continuationResponse);
    print('Continuation lines: ${continuation.length}');
    print('---\n');

    // 4. Test Title Generation
    print('4. Testing Title Generation:');
    final titleResponse =
        await groq.getChatTitle('learning German verbs and grammar');
    print(
        'Generated Title: ${titleResponse['chat_title'] ?? titleResponse.toString()}');
    print('---\n');

    // 5. Test General Search
    print('5. Testing General Search:');
    final searchResponse = await groq.getGeneralSearch(
      query: 'How to conjugate German verbs in present tense',
      chatHistory: 'Previous discussion about German language',
    );
    if (searchResponse.containsKey('text_response')) {
      final text = searchResponse['text_response'] as String;
      print('Search result preview: ${text.substring(0, 200)}...');
    }
    print('---\n');

    // 6. Test German Quiz
    print('6. Testing German Quiz for "beginner":');
    final quizResponse = await groq.getGermanQuiz('beginner');
    final quizQuestions = ResponseParser.parseQuizResponse(quizResponse);
    print('Number of questions generated: ${quizQuestions.length}');
    if (quizQuestions.isNotEmpty) {
      print('First question: ${quizQuestions[0]['question']}');
      print('Correct answer: ${quizQuestions[0]['correct_answer']}');
    }
    print('---\n');

    // 7. Test raw prompt (for custom use)
    print('7. Testing Raw Prompt:');
    final customPrompt =
        'Explain the difference between "sein" and "haben" in German.';
    final rawResponse = await groq.sendPrompt(prompt: customPrompt);
    if (rawResponse.containsKey('text_response')) {
      final text = rawResponse['text_response'] as String;
      print('Response: ${text.substring(0, 300)}...');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Add this to your pubspec.yaml dependencies:
/*
dependencies:
  http: ^1.1.0
  # Also add the prompt classes we created earlier
*/
