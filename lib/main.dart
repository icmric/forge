import 'package:flutter/material.dart';
import 'package:forge/infinite_canvas.dart';
import 'package:random_color/random_color.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Example(),
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final List<InfiniteCanvasNode> _nodes = [];
  final GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infinite Canvas Example')),
      body: GestureDetector(
        onTapDown: (details) {
          // 1. Get RenderBox of InfiniteCanvas:
          final RenderBox canvasRenderBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;

          // 2. Get size of options bar (you might need to adjust this):
          final double optionsBarHeight = AppBar().preferredSize.height; // Assuming options bar has same height as AppBar

          // 3. Adjust click offset to exclude options bar:
          Offset adjustedOffset = details.localPosition;
          adjustedOffset = Offset(
            adjustedOffset.dx,
            adjustedOffset.dy - optionsBarHeight * 1.7,
          );

          // 4. Convert to global coordinates:
          final Offset globalOffset = canvasRenderBox.localToGlobal(adjustedOffset);

          _addSquareNode(globalOffset);
        },
        child: InfiniteCanvas(
          key: _canvasKey,
          controller: InfiniteCanvasController(
            nodes: _nodes,
            edges: [],
          ),
        ),
      ),
    );
  }

  void _addSquareNode(Offset offset) {
    final key = UniqueKey();
    final squareSize = 50.0;

    final Offset adjustedOffset = Offset(squareSize / 2, squareSize / 2);

    setState(() {
      _nodes.add(
        InfiniteCanvasNode(
          key: key,
          offset: offset - adjustedOffset,
          size: Size(squareSize, squareSize),
          child: Container(
            color: RandomColor().randomColor(),
          ),
        ),
      );
    });
  }
}
