import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _AppDrawerState();
  }

}

class _AppDrawerState extends State<AppDrawer> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
    ).. forward();

    _slideAnimation =Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut)
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget buildAnimatedItem(Widget child, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, childWidget) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value + index * 5),
          child: Opacity(
            opacity: _controller.value,
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }
  @override
  Widget build(BuildContext context) {
    final List<ListTile> items = [
      ListTile(
        leading: const Icon(Icons.person, color: Colors.deepPurple),
        title: const Text('Hồ sơ cá nhân'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.settings, color: Colors.teal),
        title: const Text('Cài đặt'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.bar_chart, color: Colors.orange),
        title: const Text('Thống kê'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.feedback, color: Colors.blueAccent),
        title: const Text('Gửi ý kiến'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.help_outline, color: Colors.green),
        title: const Text('Trợ giúp'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.info_outline, color: Colors.indigo),
        title: const Text('Phiên bản ứng dụng'),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationName: 'Tracking Positive',
            applicationVersion: 'v1.0.0',
            applicationIcon: const Icon(Icons.track_changes),
            children: const [Text('Ứng dụng theo dõi và phát triển thói quen tốt cho GenZ.')],
          );
        },
      ),
    ];

    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
            ),
            accountName: Text("Lê Minh"),
            accountEmail: Text("leminh@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context,index){
                return buildAnimatedItem(items[index], index);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Đăng xuất'),
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}

