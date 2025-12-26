import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_providers.dart';

class UsersListTab extends ConsumerWidget {
  const UsersListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userListProvider);

    return Scaffold(
      // Using Scaffold here to easily place FAB relative to this tab
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
      body: users.isEmpty
          ? const Center(child: Text("No users added yet"))
          : ListView.builder(
              key: const PageStorageKey(
                'users_list',
              ), // Preserves scroll position
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(user.initials)),
                  title: Text(user.name),
                  onTap: () {
                    context.go(
                      '/chat/${user.id}',
                      extra: {'userName': user.name},
                    );
                  },
                );
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
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "User Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(userListProvider.notifier).addUser(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("User added: ${controller.text}")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
