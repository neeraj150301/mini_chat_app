import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_providers.dart';

class ChatHistoryTab extends ConsumerWidget {
  const ChatHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(chatHistoryProvider);

    return ListView.builder(
      key: const PageStorageKey('chat_history'), // Preserves scroll position
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return ListTile(
          leading: CircleAvatar(child: Text(session.user.initials)),
          title: Text(session.user.name),
          subtitle: Text(
            session.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            DateFormat.jm().format(session.lastMessageTime),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            context.go(
              '/chat/${session.user.id}',
              extra: {'userName': session.user.name},
            );
          },
        );
      },
    );
  }
}
