import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mini_chat_app/features/chat/domain/chat_session.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_providers.dart';

class ChatHistoryTab extends ConsumerWidget {
  const ChatHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(chatHistoryProvider);

    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text("No recent chats", style: TextStyle(color: Colors.grey[500])),
          ],
        ).animate().fadeIn().scale(),
      );
    }

    return ListView.builder(
      key: const PageStorageKey('chat_history'),
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _SessionListItem(session: session, index: index);
      },
    );
  }
}

class _SessionListItem extends StatelessWidget {
  final ChatSession session;
  final int index;

  const _SessionListItem({required this.session, required this.index});

  @override
  Widget build(BuildContext context) {
    final color =
        Colors.primaries[session.user.id.hashCode % Colors.primaries.length];
    final int unreadCount = session.unreadCount;

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF94A3B8).withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                context.go(
                  '/chat/${session.user.id}',
                  extra: {'userName': session.user.name},
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Hero(
                      tag: session.user.id,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [color.shade400, color.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 26,
                          child: CircleAvatar(
                            backgroundColor: color.shade50,
                            foregroundColor: color.shade700,
                            radius: 23,
                            child: Text(
                              session.user.initials,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                session.user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                _formatTime(session.lastMessageTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: unreadCount > 0
                                      ? Color(0xFF2563EB)
                                      : Colors.grey[400],
                                  fontWeight: unreadCount > 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  session.lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: unreadCount > 0
                                        ? Colors.black87
                                        : Colors.grey[500],
                                    fontWeight: unreadCount > 0
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (unreadCount > 0)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2563EB),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFF2563EB,
                                        ).withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    unreadCount > 9
                                        ? "9+"
                                        : unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ).animate().scale(curve: Curves.elasticOut),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: (50 * index).ms)
        .fadeIn()
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      if (now.difference(time).inMinutes < 60) {
        return "${now.difference(time).inMinutes} min ago";
      }
      return DateFormat.jm().format(time);
    } else if (now.difference(time).inDays == 1) {
      return "Yesterday";
    }
    return DateFormat.MMMd().format(time);
  }
}
