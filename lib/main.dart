import 'package:flutter/material.dart';
import 'design/app_theme.dart';
import 'data/session_store.dart';

// Screens
import 'screens/onboarding_screen.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/home_shell.dart';
import 'screens/tools/browse_tools_page.dart';
import 'screens/tools/tool_detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await SessionStore.isLoggedIn();
  runApp(MyApp(initialRoute: loggedIn ? '/home' : '/onboarding'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KisatoKisan',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/signin': (_) => const SignInScreen(),
        '/forgot': (_) => const ForgotPasswordScreen(),
        '/home': (_) => const HomeShell(),
        '/browse': (_) => const BrowseToolsPage(),
        '/tool': (_) => const ToolDetailPage(),
      },
    );
  }
}
