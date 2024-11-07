import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gappy/features/auth/models/user_model.dart';
import 'package:gappy/features/shared/colors/colors.dart';
import 'package:gappy/utils/routes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sizer/sizer.dart';
import 'features/feed/models/post_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open necessary boxes
  await Hive.openBox('authBox');
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<String>('sessionBox');
  final userBox = await Hive.openBox<User>('userBox');

  // Check if user is logged in
  final loggedInEmail = Hive.box<String>('sessionBox').get('loggedInEmail');
  final isLoggedIn =
      loggedInEmail != null && userBox.containsKey(loggedInEmail);

  print('User logged in: $isLoggedIn');

  // Run the app
  runApp(
    ProviderScope(
      child: MyApp(
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,

        title: 'Gappy App',
        theme: ThemeData(
          fontFamily: 'Wavehaus',

          scaffoldBackgroundColor: screenBackgroundColor,
          // useMaterial3: true,
        ),
        // home: isLoggedIn ? Entry() : LoginPage(),
        routerConfig: createRouter(isLoggedIn),
      );
    });
  }
}
