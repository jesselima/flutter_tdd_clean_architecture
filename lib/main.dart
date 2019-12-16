import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  /* Inject Dependencies from injection_container.dart
  *  The runApp(MyApp()) will be called only after avery single dependency is initialized
  * */
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Number Trivia",
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600
      ),
      home: NumberTriviaPage()
    );
  }
}