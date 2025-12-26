import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_chat_app/features/chat/data/chat_repository.dart';
import 'package:mini_chat_app/features/chat/domain/chat_session.dart';
import 'package:mini_chat_app/features/chat/domain/message.dart';
import 'package:mini_chat_app/features/chat/domain/user.dart';
import 'package:uuid/uuid.dart';

final dioProvider = Provider((ref) => Dio());

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(ref.watch(dioProvider));
});

class UserListNotifier extends StateNotifier<List<User>> {
  UserListNotifier() : super([]);

  void addUser(String name) {
    if (name.trim().isEmpty) return;
    final newUser = User(id: const Uuid().v4(), name: name);
    state = [...state, newUser];
  }

  User? getUser(String id) {
    try {
      return state.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }
}

final userListProvider = StateNotifierProvider<UserListNotifier, List<User>>((
  ref,
) {
  return UserListNotifier();
});

class ChatMessagesNotifier extends StateNotifier<List<Message>> {
  final ChatRepository _repository;
  final String _chatId;
  final Ref _ref;

  ChatMessagesNotifier(this._repository, this._chatId, this._ref) : super([]);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      id: const Uuid().v4(),
      text: text,
      senderId: 'me',
      timestamp: DateTime.now(),
      isMe: true,
    );

    state = [newMessage, ...state];
    _updateHistory(newMessage);

    await Future.delayed(const Duration(seconds: 1));
    _receiveReply();
  }

  Future<void> _receiveReply() async {
    final replyText = await _repository.fetchRandomReply();
    final replyMessage = Message(
      id: const Uuid().v4(),
      text: replyText,
      senderId: _chatId,
      timestamp: DateTime.now(),
      isMe: false,
    );

    state = [replyMessage, ...state];
    _updateHistory(replyMessage);
  }

  void _updateHistory(Message lastMessage) {
    _ref.read(chatHistoryProvider.notifier).updateSession(_chatId, lastMessage);
  }
}

final chatMessagesProvider =
    StateNotifierProvider.family<ChatMessagesNotifier, List<Message>, String>((
      ref,
      chatId,
    ) {
      final repository = ref.watch(chatRepositoryProvider);
      return ChatMessagesNotifier(repository, chatId, ref);
    });

class ChatHistoryNotifier extends StateNotifier<List<ChatSession>> {
  final Ref _ref;
  ChatHistoryNotifier(this._ref) : super([]);

  void updateSession(String userId, Message lastMessage) {
    final userList = _ref.read(userListProvider);
    User? user;
    try {
      user = userList.firstWhere((u) => u.id == userId);
    } catch (_) {
      return;
    }

    int currentUnread = 0;
    try {
      final existingSession = state.firstWhere((s) => s.id == userId);
      currentUnread = existingSession.unreadCount;
    } catch (_) {}

    int newUnreadCount = currentUnread;
    if (!lastMessage.isMe) {
      newUnreadCount++;
    } else {
      newUnreadCount = 0;
    }

    final newSession = ChatSession(
      id: userId,
      user: user,
      lastMessage: lastMessage.text,
      lastMessageTime: lastMessage.timestamp,
      unreadCount: newUnreadCount,
    );

    final otherSessions = state.where((s) => s.id != userId).toList();
    state = [newSession, ...otherSessions];
  }

  void markSessionAsRead(String userId) {
    if (!state.any((s) => s.id == userId)) return;

    state = state.map((session) {
      if (session.id == userId) {
        return ChatSession(
          id: session.id,
          user: session.user,
          lastMessage: session.lastMessage,
          lastMessageTime: session.lastMessageTime,
          unreadCount: 0,
        );
      }
      return session;
    }).toList();
  }
}

final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, List<ChatSession>>((ref) {
      return ChatHistoryNotifier(ref);
    });
