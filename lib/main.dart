import "package:challenge_tag/challenge_tag.dart";
import "package:fltr_m_001_random_meal_generator/screens/home_screen.dart";
import "package:flutter/material.dart";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Random Meal Generator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Hermit",
      ),
      home: const Stack(
        children: [
          HomeScreen(),
          Opacity(
            opacity: 0.8,
            child: ChallengeTag(
              size: 14.0,
              radius: 2.0,
<<<<<<< HEAD
              font: "Hermit",
=======
>>>>>>> 422fc545c206527df06f734c9e920c89d8d9a2e5
            ),
          ),
        ],
      ),
    );
  }
}
