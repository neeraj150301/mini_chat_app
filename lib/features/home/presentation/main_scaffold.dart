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
    const Center(child: Text("Offers")),
    const Center(child: Text("Settings")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey[400],
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              .new(
                icon: Icon(Icons.message_outlined),
                activeIcon: Icon(Icons.message),
                label: "Home",
              ),
              .new(icon: Icon(Icons.local_offer_outlined), label: "Offers"),
              .new(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
