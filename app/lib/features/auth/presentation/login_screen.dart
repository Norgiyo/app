import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../profile/presentation/team_select_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  Future<void> _loginOrRegister() async {
    final email = _email.text.trim();
    final pass = _pass.text;

    if (email.isEmpty || pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pon correo y contrasena (min 6).')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      // intenta login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseAuthException catch (e) {
      // si no existe, lo registramos
      if (e.code == 'user-not-found') {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
      } else if (e.code == 'wrong-password') {
        rethrow;
      } else {
        rethrow;
      }
    } finally {
      setState(() => _loading = false);
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TeamSelectScreen()),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
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
            const SizedBox(height: 12),
            TextField(
              controller: _pass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contrasena (temporal)'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _loginOrRegister,
                child: Text(_loading ? '...' : 'Entrar / Crear cuenta'),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Luego cambiamos esto a Magic Link (solo correo, sin password).',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


