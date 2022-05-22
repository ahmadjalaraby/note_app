import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_project/data/data.dart';
import 'package:lab_project/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: defaultColor,
        appBarTheme: AppBarTheme(
          color: defaultColor,
          toolbarTextStyle: TextTheme(
            headline6: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 20,
            ),
          ).bodyText2,
          titleTextStyle: TextTheme(
            headline6: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 20,
            ),
          ).headline6,
        ),
        textTheme: TextTheme(
          headline6: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 20,
          ),
          bodyText1: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 16,
          ),
          bodyText2: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
