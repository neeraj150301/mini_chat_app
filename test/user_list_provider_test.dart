import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_providers.dart';

void main() {
  test('UserListNotifier starts empty', () {
    final container = ProviderContainer();
    final users = container.read(userListProvider);
    expect(users, isEmpty);
  });

  test('UserListNotifier adds user', () {
    final container = ProviderContainer();
    final notifier = container.read(userListProvider.notifier);

    notifier.addUser('Alice');
    expect(container.read(userListProvider).length, 1);
    expect(container.read(userListProvider).first.name, 'Alice');
  });

  test('UserListNotifier does not add empty name', () {
    final container = ProviderContainer();
    final notifier = container.read(userListProvider.notifier);

    notifier.addUser('   ');
    expect(container.read(userListProvider), isEmpty);
  });
}
