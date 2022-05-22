import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_project/data/data.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: splashDuration),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.,
          children: [
            Column(
              children: [
                const SizedBox(
                  width: 200,
                  height: 200,
                  child: Icon(
                    Icons.note_rounded,
                    size: 130,
                  ),
                ),
                Text(
                  appName,
                  style: GoogleFonts.dancingScript(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5.0,
                  ),
                ),
              ],
            ),
            Column(
              children: const [
                SizedBox(height: 20),
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(defaultColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
