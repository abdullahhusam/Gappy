// app_router.dart
import 'package:flutter/material.dart';
import 'package:gappy/features/feed/views/create_post_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:gappy/features/auth/views/login_screen.dart';
import 'package:gappy/features/auth/views/sign_up_screen.dart';
import 'package:gappy/features/feed/views/home_screen.dart';
import 'package:gappy/features/shared/entry_screen.dart';

// Define route paths
const String loginPath = '/login';
const String signUpPath = '/signUp';
const String homePath = '/home';
const String entryPath = '/entry';
const String createPostPath = '/createPost';

// Function to create a GoRouter instance based on the login status
GoRouter createRouter(bool isLoggedIn) {
  return GoRouter(
    initialLocation: isLoggedIn ? entryPath : loginPath,
    routes: [
      GoRoute(
        path: loginPath,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: signUpPath,
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: homePath,
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: entryPath,
        builder: (context, state) => Entry(),
      ),
      GoRoute(
        path: createPostPath,
        builder: (context, state) => CreatePostPage(),
      ),
    ],
  );
}
