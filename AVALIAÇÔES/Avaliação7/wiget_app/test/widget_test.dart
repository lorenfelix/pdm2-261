import 'package:flutter_test/flutter_test.dart';
import 'package:wiget_app/main.dart';

void main() {
  testWidgets('Verifica se a tela inicial aparece',
      (WidgetTester tester) async {

    // Carrega o app
    await tester.pumpWidget(const MeuApp());

    // Verifica textos da tela
    expect(find.text('Loren - Home Widget'), findsOneWidget);

    expect(find.text('Projeto Flutter Home Widget'),
        findsOneWidget);

    expect(find.text('Aluno: Loren'),
        findsOneWidget);
  });
}