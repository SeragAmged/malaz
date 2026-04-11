import 'package:flutter/material.dart';

import 'features/rooms/presentation/pages/rooms_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';

class MalazApp extends StatelessWidget {
  const MalazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malaz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC86F4A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F3EC),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        '/rooms': (context) => const RoomsPage(),
      },
    );
  }
}
