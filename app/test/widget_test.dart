import 'package:app/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Enviar Magic Link'), findsOneWidget);
    expect(
      find.text('Te enviaremos un enlace de acceso sin contrasena.'),
      findsOneWidget,
    );
  });
}
