import 'package:flutter/material.dart';
import 'package:tracking_positive_mobile/presentation/pages/HomePage/tabs/ChallengePage/challenge_tab.dart';
import 'package:tracking_positive_mobile/presentation/pages/HomePage/tabs/CommunityPage/community_tab.dart';
import 'package:tracking_positive_mobile/presentation/pages/HomePage/tabs/ExplorePage/explore_tab.dart';
import 'package:tracking_positive_mobile/presentation/pages/HomePage/tabs/homePage/home_tab.dart';
import '../../widgets/appBar/AppDrawer.dart';

class HomeControllerPage extends StatefulWidget {
  const HomeControllerPage({super.key});

  @override
  State<HomeControllerPage> createState() => _HomeControllerPageState();
}

class _HomeControllerPageState extends State<HomeControllerPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeTab(),
    ExploreTab(),
    Center(child: Text("Quét QR", style: TextStyle(fontSize: 24))),
    ChallengeTab(),
    CommunityTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Habit"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Colors.black),
        onPressed: () {
          _onItemTapped(2);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ✅ Custom Bottom Navigation Bar với rãnh
      bottomNavigationBar:
        SafeArea(
          child:
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home, 'Trang chủ', 0),
                    _buildNavItem(Icons.explore, 'Khám phá', 1),
                    const SizedBox(width: 48),
                    _buildNavItem(Icons.flag, 'Thử thách', 3),
                    _buildNavItem(Icons.group, 'Cộng đồng', 4),
                  ],
                ),
              ),
            )

        )
    );
  }
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? Colors.blue : Colors.grey;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: isSelected ? 1.2 : 1.0),
              duration: const Duration(milliseconds: 250),
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: Icon(icon, color: color),
              ),
            ),
            const SizedBox(height: 1),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}


