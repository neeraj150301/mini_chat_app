import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_chat_app/features/chat/domain/user.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_providers.dart';

class UsersListTab extends ConsumerWidget {
  const UsersListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton:
          FloatingActionButton(
            onPressed: () {
              _showAddUserDialog(context, ref);
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ).animate().scale(
            delay: 500.ms,
            duration: 300.ms,
            curve: Curves.easeOutBack,
          ),
      body: users.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group_off_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No users yet",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ).animate().fadeIn().scale(),
            )
          : ListView.builder(
              key: const PageStorageKey('users_list'),
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _UserListItem(user: user, index: index);
              },
            ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add User"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "User Name",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(userListProvider.notifier).addUser(controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User user;
  final int index;

  const _UserListItem({required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    // Generate a consistent color based on user ID
    final color = Colors.primaries[user.id.hashCode % Colors.primaries.length];

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
          tag: user.id,
          child: CircleAvatar(
            backgroundColor: color.shade100,
            foregroundColor: color.shade700,
            radius: 24,
            child: Text(
              user.initials,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              "Online",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
        onTap: () {
          context.go('/chat/${user.id}', extra: {'userName': user.name});
        },
      ),
    ).animate(delay: (50 * index).ms).fadeIn().slideX(begin: 0.1);
  }
}
