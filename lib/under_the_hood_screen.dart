import 'package:flutter/material.dart';

class UnderTheHoodScreen extends StatefulWidget {
  const UnderTheHoodScreen({super.key});

  @override
  State<UnderTheHoodScreen> createState() => _UnderTheHoodScreenState();
}

class _UnderTheHoodScreenState extends State<UnderTheHoodScreen> {
  Color _color = Colors.blue;

  void _toggleColor() {
    setState(() {
      _color = _color == Colors.blue ? Colors.red : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Under The Hood'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Check your debug console! This custom widget logs when its RenderObject is created or updated.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Our custom LeafRenderObjectWidget
            SimpleBox(color: _color),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _toggleColor, child: const Text('Update RenderObject Color')),
          ],
        ),
      ),
    );
  }
}

// 1. THE WIDGET
// Immutable configuration.
class SimpleBox extends LeafRenderObjectWidget {
  final Color color;

  const SimpleBox({super.key, required this.color});

  @override
  RenderObject createRenderObject(BuildContext context) {
    debugPrint('🟢 [Widget] createRenderObject called. Creating RenderSimpleBox.');
    return RenderSimpleBox(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderSimpleBox renderObject) {
    debugPrint('🔵 [Widget] updateRenderObject called. Updating color to $color.');
    renderObject.color = color;
  }
}

// 2. THE RENDER OBJECT
// Mutable object that handles painting and layout.
class RenderSimpleBox extends RenderBox {
  Color _color;

  RenderSimpleBox({required Color color}) : _color = color;

  Color get color => _color;

  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint(); // Tell the pipeline we need to repaint
  }

  @override
  void performLayout() {
    // We give ourselves a fixed size
    size = constraints.constrain(const Size(100, 100));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    debugPrint('🎨 [RenderObject] paint called.');
    final Paint paint = Paint()..color = _color;
    context.canvas.drawRect(offset & size, paint);
  }
}
