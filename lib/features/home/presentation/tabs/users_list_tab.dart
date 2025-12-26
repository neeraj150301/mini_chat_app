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
            shape: const CircleBorder(),
            onPressed: () {
              _showAddUserDialog(context, ref);
            },
            backgroundColor: Color(0xFF2563EB),
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
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Add User",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Center(
                child: Text(
                  "New Conversation",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintText: "Enter user name",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            foregroundColor: Colors.grey[600],
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              final name = controller.text.trim();
                              ref.read(userListProvider.notifier).addUser(name);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text("User '$name' added"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF2563EB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Add User",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User user;
  final int index;

  const _UserListItem({required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final color = Colors.primaries[user.id.hashCode % Colors.primaries.length];

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
                context.go('/chat/${user.id}', extra: {'userName': user.name});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Hero(
                      tag: user.id,
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
                              user.initials,
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
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF22C55E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Online",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey[300],
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: (100 * index).ms)
        .fadeIn()
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }
}
