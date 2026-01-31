import 'package:flutter/material.dart';

class ContextAccessScreen extends StatelessWidget {
  const ContextAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Context Access Demo'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'We wrap the section below in a SPECIAL GREEN THEME.\n'
                'Notice which widget listens to it, and which ignores it.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // We define a local theme override here (GREEN)
            Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(color: Colors.green, size: 50),
                textTheme: Theme.of(context).textTheme.copyWith(
                  bodyMedium: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
              child: Column(
                children: [
                  // 1. HELPER METHOD
                  // Passing 'context' here is the TRAP.
                  // It passes the context from 'ContextAccessScreen.build',
                  // which is ABOVE the 'Theme' widget we just defined.
                  _buildHelperWidget(context),

                  const SizedBox(height: 20),

                  // 2. CUSTOM WIDGET
                  // This widget is a child of the Theme.
                  // Its internal build method will look up the tree and find the Green Theme.
                  const CustomContextWidget(),

                  const SizedBox(height: 20),

                  // 3. BUILDER WIDGET (The Inline Fix)
                  // Creates a new context inline, allowing us to see the parent Theme
                  Builder(
                    builder: (newContext) {
                      final color = Theme.of(newContext).iconTheme.color;
                      return Card(
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text('Builder Widget'),
                              const SizedBox(height: 8),
                              Icon(Icons.construction, color: color),
                              const SizedBox(height: 4),
                              const Text(
                                'I create a new context inline,\nso I ALSO see the Green Theme!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER METHOD
  Widget _buildHelperWidget(BuildContext context) {
    // This context comes from the parent's build method (ABOVE the green theme).
    // So looking up Theme.of(context) finds the default app theme (Purple), not Green.
    final color = Theme.of(context).iconTheme.color;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Helper Method'),
            const SizedBox(height: 8),
            Icon(Icons.warning, color: color),
            const SizedBox(height: 4),
            const Text('I am using parent context,\nso I ignore the local Green Theme!', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// CUSTOM WIDGET
class CustomContextWidget extends StatelessWidget {
  const CustomContextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 'context' here is the element for THIS widget.
    // It is located BELOW the Theme widget in the tree.
    // So Theme.of(context) correctly finds the Green Theme.
    final color = Theme.of(context).iconTheme.color;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Custom Widget'),
            const SizedBox(height: 8),
            Icon(Icons.check_circle, color: color),
            const SizedBox(height: 4),
            const Text('I have my own context,\nso I see the Green Theme!', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
