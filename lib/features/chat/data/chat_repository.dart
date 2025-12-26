import 'dart:math';
import 'package:dio/dio.dart';

class ChatRepository {
  final Dio _dio;
  final _random = Random();

  ChatRepository(this._dio);

  Future<String> fetchRandomReply() async {
    try {
      final skip = _random.nextInt(100);

      final response = await _dio.get(
        'https://dummyjson.com/comments',
        queryParameters: {'limit': 1, 'skip': skip, 'select': 'body,user'},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['comments'] != null && (data['comments'] as List).isNotEmpty) {
          final comment = data['comments'][0];
          final body = comment['body'];
          return body.toString();
        }
      }
      return "Hello! I am a bot.";
    } catch (e) {
      return "Sorry, I couldn't connect to the server.";
    }
  }

  Future<Map<String, dynamic>?> getWordDefinition(String word) async {
    try {
      final response = await _dio.get(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
      );
      if (response.statusCode == 200 && (response.data as List).isNotEmpty) {
        return response.data[0];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
