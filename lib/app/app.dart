import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../presentation/pages/home_feed_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Feed Clone',
      theme: AppTheme.light,
      home: const HomeFeedPage(),
    );
  }
}