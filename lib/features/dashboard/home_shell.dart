import 'package:ai_core_health/core/services/auth_service.dart';
import 'package:ai_core_health/core/services/firestore_service.dart';
import 'package:ai_core_health/features/auth/login_screen.dart';
import 'package:ai_core_health/features/dashboard/dashboard_page.dart';
import 'package:ai_core_health/features/pantry/pantry_page.dart';
import 'package:ai_core_health/features/plans/plans_page.dart';
import 'package:ai_core_health/features/profile/profile_page.dart';
import 'package:ai_core_health/features/scan/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      FirestoreService.instance.ensureStarterData(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'Health User',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data ?? AuthService.instance.currentUser;
        if (user == null) {
          return const LoginScreen();
        }

        final pages = [
          DashboardPage(uid: user.uid),
          ScanPage(uid: user.uid),
          PlansPage(uid: user.uid),
          PantryPage(uid: user.uid),
          ProfilePage(uid: user.uid),
        ];

        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (value) =>
                setState(() => _currentIndex = value),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: '首页',
              ),
              NavigationDestination(
                icon: Icon(Icons.document_scanner_outlined),
                label: '识别',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                label: '计划',
              ),
              NavigationDestination(
                icon: Icon(Icons.kitchen_outlined),
                label: '冰箱',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: '我的',
              ),
            ],
          ),
        );
      },
    );
  }
}
