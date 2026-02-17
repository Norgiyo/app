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

    final emailLink = _extractEmailLink(uri);
    if (emailLink == null) return;

    final prefs = await SharedPreferences.getInstance();
    final pendingEmail =
        prefs.getString(_pendingEmailKey) ?? _extractEmail(uri);
    if (pendingEmail == null || pendingEmail.isEmpty) return;

    await FirebaseAuth.instance.signInWithEmailLink(
      email: pendingEmail,
      emailLink: emailLink,
    );
    await prefs.remove(_pendingEmailKey);
  }

  static String? _extractEmailLink(Uri sourceUri) {
    final candidates = <String>{
      sourceUri.toString(),
      sourceUri.queryParameters['link'] ?? '',
      sourceUri.queryParameters['deep_link_id'] ?? '',
    };

    for (final raw in candidates) {
      if (raw.isEmpty) continue;
      final decoded = Uri.decodeFull(raw);
      if (FirebaseAuth.instance.isSignInWithEmailLink(decoded)) {
        return decoded;
      }
    }

    return null;
  }

  static String? _extractEmail(Uri sourceUri) {
    final directEmail = sourceUri.queryParameters['email'];
    if (directEmail != null && directEmail.isNotEmpty) return directEmail;

    final continueUrl = sourceUri.queryParameters['continueUrl'];
    if (continueUrl == null || continueUrl.isEmpty) return null;

    final continueUri = Uri.tryParse(Uri.decodeFull(continueUrl));
    return continueUri?.queryParameters['email'];
  }
}
