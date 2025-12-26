import 'package:flutter/material.dart';
import 'package:mini_chat_app/features/home/presentation/home_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text("Placeholder Tab 1")),
    const Center(child: Text("Placeholder Tab 2")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ), // Placeholder
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ), // Placeholder
        ],
      ),
    );
  }
}
