import 'package:go_router/go_router.dart';
import 'package:mini_chat_app/features/home/presentation/main_scaffold.dart';
import 'package:mini_chat_app/features/chat/presentation/chat_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScaffold(),
      routes: [
        GoRoute(
          path: 'chat/:chatId',
          builder: (context, state) {
            final chatId = state.pathParameters['chatId']!;
            final extra = state.extra as Map<String, dynamic>?;
            final userName = extra?['userName'] as String? ?? 'Unknown';
            return ChatScreen(chatId: chatId, userName: userName);
          },
        ),
      ],
    ),
  ],
);
