import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'features/auth/data/magic_link_signin_handler.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/profile/data/user_profile_repository.dart';
import 'features/profile/presentation/team_select_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  final UserProfileRepository _userProfileRepository = UserProfileRepository();
  StreamSubscription<Uri>? _linksSub;
  StreamSubscription<User?>? _authSub;

  @override
  void initState() {
    super.initState();
    _startMagicLinkListener();
    _startAuthProfileSync();
  }

  Future<void> _startMagicLinkListener() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      await MagicLinkSignInHandler.tryCompleteSignInFromUri(initialUri);
    } catch (_) {
      // Ignore startup deep-link errors and keep auth flow usable.
    }

    _linksSub = _appLinks.uriLinkStream.listen((uri) async {
      try {
        await MagicLinkSignInHandler.tryCompleteSignInFromUri(uri);
      } catch (_) {
        // Ignore runtime deep-link errors and keep auth flow usable.
      }
    });
  }

  void _startAuthProfileSync() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) return;
      try {
        await _userProfileRepository.ensureUserProfile(user);
      } catch (_) {
        // Ignore profile bootstrap errors to avoid blocking login UI.
      }
    });
  }

  @override
  void dispose() {
    _linksSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1Cup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginScreen();
          }
          return const TeamSelectScreen();
        },
      ),
    );
  }
}
