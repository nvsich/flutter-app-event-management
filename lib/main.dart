import 'package:cursach_app/core/common/app/providers/user_provider.dart';
import 'package:cursach_app/core/services/injection_container.dart';
import 'package:cursach_app/core/services/router.dart';
import 'package:cursach_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Cursach',
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(color: Colors.transparent),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
