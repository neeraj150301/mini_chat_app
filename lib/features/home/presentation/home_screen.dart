import 'package:flutter/material.dart';
import 'package:mini_chat_app/features/home/presentation/tabs/chat_history_tab.dart';
import 'package:mini_chat_app/features/home/presentation/tabs/users_list_tab.dart';
import 'package:mini_chat_app/features/home/presentation/widgets/segmented_tab_control.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Column(
                  children: [
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      // child: PreferredSize(
                      //   preferredSize: const Size.fromHeight(58),
                      child: SegmentedTabControl(
                        controller: _tabController,
                        tabs: const ["Users", "Chat History"],
                      ),
                      // ),
                    ),
                  ],
                ),
                centerTitle: true,
                floating: true,
                snap: true,
                pinned: false,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(16),
                  child: Divider(height: 8),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [UsersListTab(), ChatHistoryTab()],
          ),
        ),
      ),
    );
  }
}
