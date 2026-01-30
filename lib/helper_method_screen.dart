import 'package:flutter/material.dart';

class HelperMethodScreen extends StatefulWidget {
  const HelperMethodScreen({super.key});

  @override
  State<HelperMethodScreen> createState() => _HelperMethodScreenState();
}

class _HelperMethodScreenState extends State<HelperMethodScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void dispose() {
    _buildCounts.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helper Method Demo'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'When you tap the Floating Action Button, the entire screen rebuilds, '
                'which causes all items in the list below to also rebuild, '
                'even though their data hasn\'t changed.',
                textAlign: TextAlign.center,
              ),
            ),
            Text('Counter: $_counter', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return _buildListItem(index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _incrementCounter, tooltip: 'Increment', child: const Icon(Icons.add)),
    );
  }

  // Static map to track build counts for demo purposes
  static final Map<int, int> _buildCounts = {};

  // HELPER METHOD
  // This method is called every time _HelperMethodScreenState.build is called.
  // There is no way for Flutter to optimize this out because it's just a function execution.
  Widget _buildListItem(int index) {
    debugPrint('Building Helper Method Item $index');

    // Increment build count
    _buildCounts[index] = (_buildCounts[index] ?? 0) + 1;
    final count = _buildCounts[index];

    // Better implementation for "Flashing":
    // Just simple Random(). But let's use a simple distinct color generator for clarity?
    // No, pure random is best for "flashing".
    final randomColor = Colors.primaries[DateTime.now().microsecondsSinceEpoch % Colors.primaries.length].withOpacity(0.2);

    return Card(
      color: randomColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text('$index')),
        title: Text('Item $index'),
        subtitle: Text('Builds: $count\n(I rebuild every time parent updates)'),
      ),
    );
  }
}
