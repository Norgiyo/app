import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Contrasena (temporal)'), findsOneWidget);
    expect(find.text('Entrar / Crear cuenta'), findsOneWidget);
  });
}
