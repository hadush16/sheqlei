import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sheqlee/screens/authentication/splash_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // optional
  ]);

  runApp(
    const ProviderScope(child: MyApp()),
    // MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AppStartScreen(),
      // initialRoute: "/splash",
      // routes: {
      //   "/splash": (context) => AppStartScreen(),
      //   "/login": (context) => IntroLoginScreen(),
      // },
      debugShowCheckedModeBanner: false,
    );
  }
}
