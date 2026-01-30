import 'package:flutter/material.dart';
import 'custom_widget_screen.dart';
import 'helper_method_screen.dart';
import 'under_the_hood_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Study',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const MyHomePage(title: 'Flutter Widget Study'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Select a demo to explore:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HelperMethodScreen()));
              },
              child: const Text('Helper Method Demo'),
            ),
            const SizedBox(height: 10),
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CustomWidgetScreen()));
              },
              child: const Text('Custom Widget Demo'),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UnderTheHoodScreen()));
              },
              icon: const Icon(Icons.build_circle_outlined),
              label: const Text('Under The Hood Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
