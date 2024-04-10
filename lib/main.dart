import 'package:flutter/material.dart';
import 'package:livraria_flutter/pages/bookDetailScreen.dart';
import 'package:livraria_flutter/pages/bookListScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, g) {
        return MaterialApp(
          initialRoute: '/',
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.values.toList()[value as int],
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (ctx) => BookListScreen(),
            //'/details': (ctx) => BookDetailScreen(book: Placeholder()),
          },
        );
      },
      valueListenable: ValueNotifier(2),
    );
  }
}
