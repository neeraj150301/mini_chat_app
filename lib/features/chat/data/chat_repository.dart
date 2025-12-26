import 'package:dio/dio.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Future<String> fetchRandomReply() async {
    try {
      final response = await _dio.get(
        'https://dummyjson.com/comments?limit=10',
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['comments'] != null && (data['comments'] as List).isNotEmpty) {
          return data['comments'][0]['body'];
        }
      }
      return "Hello! I am a bot.";
    } catch (e) {
      return "Sorry, I couldn't connect to the server.";
    }
  }
}
