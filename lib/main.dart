import 'package:flutter/material.dart';
import 'package:forge/infinite_canvas.dart';

import 'src/presentation/widgets/actions.dart';
//import 'package:infinite_canvas/infinite_canvas.dart';

//import 'canvas/infinite_canvas.dart';

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
  late InfiniteCanvasController controller;

  @override
  void initState() {
    super.initState();
    final rectangleNode = InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'Rectangle',
      offset: const Offset(400, 300),
      size: const Size(200, 200),
      child: Builder(
        builder: (context) {
          return CustomPaint(
            isComplex: true,
            willChange: true,
            painter: InlineCustomPainter(
              brush: Paint(),
              builder: (brush, canvas, rect) {
                // Draw rect
                brush.color = Theme.of(context).colorScheme.secondary;
                canvas.drawRect(rect, brush);
              },
            ),
          );
        },
      ),
    );
    final triangleNode = InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'Triangle',
      offset: const Offset(550, 300),
      size: const Size(200, 200),
      child: Builder(
        builder: (context) {
          return CustomPaint(
            painter: InlineCustomPainter(
              brush: Paint(),
              builder: (brush, canvas, rect) {
                // Draw triangle
                brush.color = Theme.of(context).colorScheme.secondaryContainer;
                final path = Path();
                path.addPolygon([
                  rect.topCenter,
                  rect.bottomLeft,
                  rect.bottomRight,
                ], true);
                canvas.drawPath(path, brush);
              },
            ),
          );
        },
      ),
    );
    final testNote = InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'Note',
      offset: const Offset(500, 150),
      size: const Size(200, 200),
      child: Builder(
        builder: (context) {
          return CustomPaint(
            painter: InlineCustomPainter(
              brush: Paint(),
              builder: (brush, canvas, rect) {
                // Draw note
                brush.color = Theme.of(context).colorScheme.secondaryContainer;
                final path = Path();
                path.addRRect(RRect.fromLTRBR(
                  rect.left,
                  rect.top,
                  rect.right,
                  rect.bottom,
                  const Radius.circular(10),
                ));
                canvas.drawPath(path, brush);
              },
            ),
          );
        },
      ),
    );
    final circleNode = InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'Circle',
      offset: const Offset(500, 450),
      size: const Size(200, 200),
      child: Builder(
        builder: (context) {
          return CustomPaint(
            painter: InlineCustomPainter(
              brush: Paint(),
              builder: (brush, canvas, rect) {
                // Draw circle
                brush.color = Theme.of(context).colorScheme.tertiary;
                canvas.drawCircle(rect.center, rect.width / 2, brush);
              },
            ),
          );
        },
      ),
    );
    //var textNode = ;
    var objSet = InfiniteCanvasNode(
        key: UniqueKey(),
        label: 'Text',
        offset: const Offset(500, 450),
        size: const Size(200, 200),
        resizeMode: ResizeMode.corners,
        content: 'Edit Me!',
        child: Builder(
          builder: (context) {
            String text = 'Test';
            return GestureDetector(
              onTap: () {
                final item = controller.selection.first;
                controller.focusNode.unfocus();
                prompt(
                  context,
                  title: 'Rename child',
                  value: item.label,
                ).then((value) {
                  controller.focusNode.requestFocus();
                  if (value == null) return;
                  item.update(label: value);
                  controller.editText(value, item);
                  item.content = value;
                  text = value;
                });
              },
              child: CustomPaint(
                willChange: true,
                painter: InlineCustomPainter(
                  brush: Paint(),
                  builder: (brush, canvas, rect) {
                    // Draw text
                    brush.color = Theme.of(context).colorScheme.tertiary;
                    final textStyle = TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                    );
                    final textSpan = TextSpan(
                      text: text,
                      style: textStyle,
                    );
                    final textPainter = TextPainter(
                      text: textSpan,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                    );
                    textPainter.layout();
                    textPainter.paint(
                      canvas,
                      rect.center - textPainter.size.center(Offset.zero),
                    );
                  },
                ),
              ),
            );
          },
        ));
    final nodes = [
      rectangleNode,
      triangleNode,
      circleNode,
      testNote,
      objSet,
    ];
    controller = InfiniteCanvasController(nodes: nodes, edges: [
      InfiniteCanvasEdge(
        from: rectangleNode.key,
        to: triangleNode.key,
        label: '4 -> 3',
      ),
      InfiniteCanvasEdge(
        from: rectangleNode.key,
        to: circleNode.key,
        label: '[] -> ()',
      ),
      InfiniteCanvasEdge(
        from: triangleNode.key,
        to: circleNode.key,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Canvas Example'),
        centerTitle: false,
      ),
      body: InfiniteCanvas(
        controller: controller,
      ),
    );
  }
}

class InlineCustomPainter extends CustomPainter {
  const InlineCustomPainter({
    required this.brush,
    required this.builder,
    this.isAntiAlias = true,
  });
  final Paint brush;
  final bool isAntiAlias;
  final void Function(Paint paint, Canvas canvas, Rect rect) builder;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    brush.isAntiAlias = isAntiAlias;
    canvas.save();
    builder(brush, canvas, rect);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
