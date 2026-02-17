import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MagicLinkSignInHandler {
  static const _pendingEmailKey = 'pending_magic_link_email';

  static Future<void> savePendingEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingEmailKey, email);
  }

  static Future<void> tryCompleteSignInFromUri(Uri? uri) async {
    if (uri == null) return;

    final emailLink = uri.toString();
    if (!FirebaseAuth.instance.isSignInWithEmailLink(emailLink)) return;

    final prefs = await SharedPreferences.getInstance();
    final pendingEmail =
        prefs.getString(_pendingEmailKey) ?? uri.queryParameters['email'];
    if (pendingEmail == null || pendingEmail.isEmpty) return;

    await FirebaseAuth.instance.signInWithEmailLink(
      email: pendingEmail,
      emailLink: emailLink,
    );
    await prefs.remove(_pendingEmailKey);
  }
}
