import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_chat_app/features/chat/domain/message.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_providers.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatHistoryProvider.notifier).markSessionAsRead(widget.chatId);
    });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      ref
          .read(chatMessagesProvider(widget.chatId).notifier)
          .sendMessage(_controller.text);
      _controller.clear();
      ref.read(chatHistoryProvider.notifier).markSessionAsRead(widget.chatId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider(widget.chatId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Hero(
              tag: widget.chatId,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors
                          .primaries[widget.chatId.hashCode %
                              Colors.primaries.length]
                          .shade400,
                      Colors
                          .primaries[widget.chatId.hashCode %
                              Colors.primaries.length]
                          .shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors
                        .primaries[widget.chatId.hashCode %
                            Colors.primaries.length]
                        .shade50,
                    child: Text(
                      widget.userName.isNotEmpty
                          ? widget.userName[0].toUpperCase()
                          : "?",
                      style: TextStyle(
                        color: Colors
                            .primaries[widget.chatId.hashCode %
                                Colors.primaries.length]
                            .shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Online",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final showTime =
                    index == messages.length - 1 ||
                    (index < messages.length - 1 &&
                        messages[index + 1].timestamp
                                .difference(message.timestamp)
                                .inMinutes
                                .abs() >
                            30);

                return Column(
                  children: [
                    if (showTime)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            DateFormat.jm().format(message.timestamp),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    MessageBubble(
                      message: message,
                      otherUserName: widget.userName,
                    ),
                  ],
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.transparent),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Message...",
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                  minLines: 1,
                  maxLines: 4,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
                .animate(target: _controller.text.isNotEmpty ? 1 : 0)
                .scale(curve: Curves.easeOutBack),
          ],
        ),
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

    final gradient = isMe
        ? LinearGradient(
            colors: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    final backgroundColor = isMe ? null : Colors.white;
    final textColor = isMe ? Colors.white : const Color(0xFF1E293B);
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
    );

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? const Color(0xFF2563EB).withOpacity(0.25)
                  : const Color(0xFF94A3B8).withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ).animate().fade().slideY(
      begin: 0.3,
      end: 0,
      duration: 300.ms,
      curve: Curves.easeOutQuad,
    );
  }
}
