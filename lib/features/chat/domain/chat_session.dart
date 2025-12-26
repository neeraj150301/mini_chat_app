import 'package:equatable/equatable.dart';
import 'package:mini_chat_app/features/chat/domain/user.dart';

class ChatSession extends Equatable {
  final String id;
  final User user;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ChatSession({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    lastMessage,
    lastMessageTime,
    unreadCount,
  ];
}
