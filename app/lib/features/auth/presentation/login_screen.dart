import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  bool _loading = false;
  static const _magicLinkUrl = String.fromEnvironment(
    'MAGIC_LINK_URL',
    defaultValue: 'https://cach-reward.firebaseapp.com/finishSignIn',
  );

  Future<void> _sendMagicLink() async {
    final email = _email.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pon un correo valido.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final actionCodeSettings = ActionCodeSettings(
        url: '$_magicLinkUrl?email=${Uri.encodeQueryComponent(email)}',
        handleCodeInApp: true,
        androidPackageName: 'com.example.app',
        androidInstallApp: true,
        androidMinimumVersion: '1',
        iOSBundleId: 'com.example.app',
      );

      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Te enviamos un enlace de acceso a $email.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo enviar el enlace: ${e.code}')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendMagicLink,
                child: Text(_loading ? 'Enviando...' : 'Enviar Magic Link'),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Te enviaremos un enlace de acceso sin contrasena.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


