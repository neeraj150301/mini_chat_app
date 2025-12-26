import 'package:flutter/material.dart';
import 'package:mini_chat_app/features/home/presentation/tabs/chat_history_tab.dart';
import 'package:mini_chat_app/features/home/presentation/tabs/users_list_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text("Mini Chat"),
              centerTitle: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Users List"),
                  Tab(text: "Chat History"),
                ],
              ),
            ),
          ];
        },
        body: const TabBarView(children: [UsersListTab(), ChatHistoryTab()]),
      ),
    );
  }
}
