import 'package:flutter/material.dart';

class CustomWidgetScreen extends StatefulWidget {
  const CustomWidgetScreen({super.key});

  @override
  State<CustomWidgetScreen> createState() => _CustomWidgetScreenState();
}

class _CustomWidgetScreenState extends State<CustomWidgetScreen> {
  // OPTIMIZATION: Use ValueNotifier
  // Instead of calling setState() which rebuilds the WHOLE build method (Scaffold, etc.),
  // we trigger listeners only on this notifier.
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  void _incrementCounter() {
    // No setState() here!
    _counter.value++;
  }

  @override
  void dispose() {
    _counter.dispose();
    CustomListItem._buildCounts.clear(); // Reset stats on exit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building CustomWidgetScreen (Scaffold & Tree)');
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Widget Demo'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Now using ValueNotifier!\n'
                'When you tap FAB, setState is NOT called.\n'
                'Only the Text widget below rebuilds.',
                textAlign: TextAlign.center,
              ),
            ),
            // OPTIMIZATION: ValueListenableBuilder
            // Only the builder function runs when _counter changes.
            // The surrounding Scaffold, Column, etc. do NOT rebuild.
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (context, value, child) {
                debugPrint('Building Counter Text: $value');
                return Text('Counter: $value', style: Theme.of(context).textTheme.headlineMedium);
              },
            ),
            const SizedBox(height: 20),
            // Still using our const list wrapper
            const Expanded(child: _ConstantListView()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _incrementCounter, tooltip: 'Increment', child: const Icon(Icons.add)),
    );
  }
}

// Separate Widget for the list
// Being a separate class allows us to use a 'const' constructor.
class _ConstantListView extends StatelessWidget {
  const _ConstantListView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return CustomListItem(index: index);
      },
    );
  }
}

// CUSTOM WIDGET
// This widget has its own Element in the tree.
// Because the constructor can be const, if we use const CustomListItem(...),
// Flutter knows it doesn't need to rebuild.
// Even without const, Flutter can determine if the parameters changed.
class CustomListItem extends StatelessWidget {
  final int index;
  // Static map to track build counts for demo purposes
  static final Map<int, int> _buildCounts = {};

  const CustomListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building Custom Widget Item $index');

    // Increment build count
    _buildCounts[index] = (_buildCounts[index] ?? 0) + 1;
    final count = _buildCounts[index];

    // Random color to visualize potential rebuilds.
    // If this widget was NOT const, it might rebuild.
    // But since it is const and the parent uses it as const, this build method WON'T run again,
    // and the color will stay the same (proving efficiency).
    final randomColor = Colors.primaries[DateTime.now().microsecondsSinceEpoch % Colors.primaries.length].withOpacity(0.2);

    return Card(
      color: randomColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text('$index')),
        title: Text('Item $index'),
        subtitle: Text('Builds: $count\n(I stays at 1 because I am const!)'),
      ),
    );
  }
}
