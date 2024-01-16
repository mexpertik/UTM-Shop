import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magaz/screens/home_page.dart';
import 'package:magaz/screens/product_section.dart';
import 'package:magaz/widgets/category_section.dart'; // make sure this import is correct

void main() {
  testWidgets('HomeScreen has a title and message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Verify if the HomeScreen contains any widgets from its structure.
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Welcome to UTM SHOP.'), findsOneWidget);
    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.byType(CategorySection), findsOneWidget);
    expect(find.byType(ProductSection), findsOneWidget);
  });

  // Add more tests for each widget as necessary.
}
