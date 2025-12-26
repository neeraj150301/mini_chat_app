import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_chat_app/features/chat/domain/message.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String userName;

  const ChatScreen({super.key, required this.chatId, required this.userName});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      ref
          .read(chatMessagesProvider(widget.chatId).notifier)
          .sendMessage(_controller.text);
      _controller.clear();
      // Scroll to bottom is handled by the reverse list view usually
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider(widget.chatId));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              child: Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0].toUpperCase()
                    : "?",
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Start from bottom
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(
                  message: message,
                  otherUserName: widget.userName,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final String otherUserName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final color = isMe ? Colors.blue[100] : Colors.grey[200];
    final avatarChar = isMe
        ? "M"
        : (otherUserName.isNotEmpty
              ? otherUserName[0].toUpperCase()
              : "?"); // M for Me

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 12,
              child: Text(avatarChar, style: const TextStyle(fontSize: 10)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                ),
              ),
              child: Text(message.text),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              child: Text(avatarChar, style: const TextStyle(fontSize: 10)),
            ),
          ],
        ],
      ),
    );
  }
}
