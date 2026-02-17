import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Enviar Magic Link'), findsOneWidget);
    expect(
      find.text('Te enviaremos un enlace de acceso sin contrasena.'),
      findsOneWidget,
    );
  });
}
