import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/main_page.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await GoogleSignIn.instance.initialize(serverClientId: '456683425958-ho68ghgv8h8kjs8bnmls7b0a026vk21p.apps.googleusercontent.com');
  } catch (_) {}

  final prefs = await SharedPreferences.getInstance();
  final initialToken = prefs.getString('token') ?? '';

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(initialRoute: initialToken.isNotEmpty ? '/main' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: const Color(0xFFDB3022),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDB3022)),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/main': (context) => const MainPage(),
      },
    );
  }
}
