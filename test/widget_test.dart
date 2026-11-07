import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pm_tugas_05/main.dart';

void main() {
  testWidgets('Ikon favorit berubah setelah ditekan', (tester) async {
    await tester.pumpWidget(const MenuUmkmApp());

    // Gulung sampai menu pertama terbangun dan terlihat
    await tester.scrollUntilVisible(find.text('Mie Gomak Arsik'), 200);

    final ikon = find.byIcon(Icons.favorite_border).first;
    await tester.ensureVisible(ikon);
    await tester.pumpAndSettle();

    // Sebelum ditekan: belum ada hati penuh
    expect(find.byIcon(Icons.favorite), findsNothing);

    await tester.tap(ikon);
    await tester.pump();

    // Sesudah ditekan: satu hati penuh
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}