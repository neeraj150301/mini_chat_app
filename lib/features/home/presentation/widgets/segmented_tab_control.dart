import 'package:flutter/material.dart';

class SegmentedTabControl extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  const SegmentedTabControl({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TabBar(
          splashBorderRadius: BorderRadius.circular(20),
          padding: EdgeInsets.zero,
          controller: controller,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey[500],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
          tabs: tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
    );
  }
}
