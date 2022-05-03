import 'package:book_club/models/auth_model.dart';
import 'package:book_club/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDHuCUWdCGUqJEE-bOXifAqetT9ST8BMRU",
      appId: "1:435158685506:web:9cfc33da09b4fc1ef55adb",
      messagingSenderId: "435158685506",
      projectId: "book-club-6f916",
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthModel?>.value(
      catchError: (_, __) => null,
      initialData: AuthModel(),
      value: AuthService().authUser,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Book Club',
          theme: AppTheme().buildTheme(),
          home: const AppRoot()),
    );
  }
}
