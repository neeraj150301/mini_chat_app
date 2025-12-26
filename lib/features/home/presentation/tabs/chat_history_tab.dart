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
    // Consistent color
    final color =
        Colors.primaries[session.user.id.hashCode % Colors.primaries.length];
    // Mock unread count based on index for demo
    final int unreadCount = index == 0 ? 2 : (index == 2 ? 1 : 0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: session.user.id,
          child: CircleAvatar(
            backgroundColor: color.shade100,
            foregroundColor: color.shade700,
            radius: 24,
            child: Text(
              session.user.initials,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(
          session.user.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            session.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: unreadCount > 0 ? Colors.black87 : Colors.grey[600],
              fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(session.lastMessageTime),
              style: TextStyle(
                fontSize: 12,
                color: unreadCount > 0
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[500],
                fontWeight: unreadCount > 0
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().scale(curve: Curves.elasticOut),
            ],
          ],
        ),
        onTap: () {
          context.go(
            '/chat/${session.user.id}',
            extra: {'userName': session.user.name},
          );
        },
      ),
    ).animate(delay: (50 * index).ms).fadeIn().slideX(begin: 0.1);
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      // Check if it's minutes ago
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
