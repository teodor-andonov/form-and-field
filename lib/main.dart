import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_scene/scene.dart' as scene;
import 'package:vector_math/vector_math.dart' as vm;

const ink = Color(0xff202c2a),
    muted = Color(0xff697570),
    paper = Color(0xfff6f5ef),
    accent = Color(0xffc7e25c);
void main() => runApp(const Atelier());
final router = GoRouter(
  routes: [
    for (final p in [
      '/',
      '/about',
      '/apps',
      '/gallery',
      '/graphicpad',
      '/architecture',
    ])
      GoRoute(
        path: p,
        builder: (c, s) => Shell(path: p),
      ),
  ],
);

class Atelier extends StatelessWidget {
  const Atelier({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: 'Form & Field',
    routerConfig: router,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: ink, surface: paper),
      scaffoldBackgroundColor: paper,
      fontFamily: 'Arial',
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
    ),
  );
}

class Shell extends StatelessWidget {
  final String path;
  const Shell({super.key, required this.path});
  @override
  Widget build(BuildContext context) {
    final editor = path == '/graphicpad' || path == '/architecture';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(path: path),
            Expanded(
              child: editor
                  ? (path == '/graphicpad'
                        ? const GraphicPad()
                        : const Architecture())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          if (path == '/')
                            const Home()
                          else if (path == '/about')
                            const About()
                          else if (path == '/apps')
                            const Apps()
                          else
                            const Gallery(),
                          const Footer(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String path;
  const Header({super.key, required this.path});
  @override
  Widget build(BuildContext c) => Container(
    height: 72,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: const BoxDecoration(
      color: paper,
      border: Border(bottom: BorderSide(color: Color(0xffd9ded4))),
    ),
    child: Row(
      children: [
        InkWell(
          onTap: () => c.go('/'),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: ink,
                child: Icon(Icons.auto_awesome, size: 16, color: accent),
              ),
              SizedBox(width: 10),
              Text(
                'FORM & FIELD',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (MediaQuery.sizeOf(c).width > 950) ...[
          nav(c, 'Home', '/'),
          nav(c, 'Applications', '/apps'),
          nav(c, 'About', '/about'),
          const SizedBox(width: 16),
        ],
        FilledButton(
          onPressed: () => c.go('/apps'),
          style: FilledButton.styleFrom(
            backgroundColor: ink,
            foregroundColor: Colors.white,
          ),
          child: const Text('Explore apps  ↗'),
        ),
      ],
    ),
  );
  Widget nav(BuildContext c, String label, String route) => TextButton(
    onPressed: () => c.go(route),
    child: Text(label, style: TextStyle(color: path == route ? ink : muted)),
  );
}

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext c) => Container(
    color: ink,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 45),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 20,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FORM & FIELD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A little space for big ideas.',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        TextButton(
          onPressed: () => c.go('/about'),
          child: const Text(
            'About this project  ↗',
            style: TextStyle(color: accent),
          ),
        ),
      ],
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext c) => Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(32, 75, 32, 65),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (c, b) {
                final narrow = b.maxWidth < 760;
                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Tag('A CREATIVE PLAYGROUND'),
                    const SizedBox(height: 24),
                    Text(
                      'Make space\nfor ideas.',
                      style: TextStyle(
                        fontSize: narrow ? 52 : 82,
                        height: .98,
                        letterSpacing: -3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 490,
                      child: Text(
                        'A thoughtfully simple collection of tools for seeing, sketching, and shaping what comes next.',
                        style: TextStyle(
                          fontSize: 19,
                          height: 1.5,
                          color: muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FilledButton(
                      onPressed: () => c.go('/apps'),
                      style: FilledButton.styleFrom(
                        backgroundColor: ink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 22,
                        ),
                      ),
                      child: const Text('Explore the workspace   ↗'),
                    ),
                  ],
                );
                final pic = ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/images/0.jpg',
                    fit: BoxFit.cover,
                    height: narrow ? 300 : 440,
                    width: double.infinity,
                  ),
                );
                return narrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [copy, const SizedBox(height: 35), pic],
                      )
                    : Row(
                        children: [
                          Expanded(child: copy),
                          Expanded(child: pic),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
      Container(
        color: const Color(0xffe9ede1),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 70),
        child: const Column(
          children: [
            SectionTitle(
              'YOUR CREATIVE TOOLKIT',
              'Three ways to get inspired.',
              'From collecting references to exploring a new form, start wherever curiosity takes you.',
            ),
            SizedBox(height: 35),
            AppCards(),
          ],
        ),
      ),
    ],
  );
}

class Tag extends StatelessWidget {
  final String text;
  const Tag(this.text, {super.key});
  @override
  Widget build(BuildContext c) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 2,
      color: Color(0xff66783a),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String eyebrow, title, description;
  const SectionTitle(this.eyebrow, this.title, this.description, {super.key});
  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Tag(eyebrow),
      const SizedBox(height: 12),
      Text(
        title,
        style: const TextStyle(
          fontSize: 40,
          letterSpacing: -1.5,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        description,
        style: const TextStyle(color: muted, fontSize: 16, height: 1.5),
      ),
    ],
  );
}

const apps = [
  (
    '01',
    'Image Gallery',
    'Find a new perspective. Browse a curated collection of places and moments.',
    '/gallery',
    Icons.grid_view,
  ),
  (
    '02',
    'Graphicpad',
    'Think with your hands. Draw, move and refine ideas on an open canvas.',
    '/graphicpad',
    Icons.gesture,
  ),
  (
    '03',
    'Architecture',
    'Explore a simple building in three dimensions and make it your own.',
    '/architecture',
    Icons.view_in_ar,
  ),
];

class AppCards extends StatelessWidget {
  const AppCards({super.key});
  @override
  Widget build(BuildContext c) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: LayoutBuilder(
        builder: (c, b) => Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final a in apps)
              SizedBox(
                width: b.maxWidth < 950 ? b.maxWidth : (b.maxWidth - 32) / 3,
                child: InkWell(
                  onTap: () => c.go(a.$4),
                  child: Container(
                    height: 280,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: paper,
                      border: Border.all(color: const Color(0xffd8ddd1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(a.$5),
                            const Spacer(),
                            Text(a.$1, style: const TextStyle(color: muted)),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          a.$2,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          a.$3,
                          style: const TextStyle(color: muted, height: 1.4),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'OPEN APP  ↗',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class Apps extends StatelessWidget {
  const Apps({super.key});
  @override
  Widget build(BuildContext c) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 70),
    child: Column(
      children: [
        SectionTitle(
          'THE WORKSPACE',
          'A tool for every idea.',
          'Choose a place to begin. Everything runs right here in your browser.',
        ),
        SizedBox(height: 40),
        AppCards(),
        SizedBox(height: 60),
      ],
    ),
  );
}

class About extends StatelessWidget {
  const About({super.key});
  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 90),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tag('ABOUT FORM & FIELD'),
            SizedBox(height: 20),
            Text(
              'Good ideas need room to grow.',
              style: TextStyle(
                fontSize: 56,
                height: 1.05,
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Form & Field is an experiment in bringing creative tools together. Collect inspiration, sketch freely, and explore spatial ideas in one quiet, connected workspace.',
              style: TextStyle(fontSize: 20, height: 1.6, color: muted),
            ),
            SizedBox(height: 35),
            Divider(),
            SizedBox(height: 25),
            Text(
              'Built with Flutter, designed for curiosity.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    ),
  );
}

const titles = [
  'Alpine stillness',
  'Into the green',
  'Forest light',
  'Open country',
  'First light',
  'Blue horizon',
  'Mountain night',
  'Valley mist',
];
const cats = [
  'Mountains',
  'Forest',
  'Forest',
  'Landscape',
  'Landscape',
  'Mountains',
  'Mountains',
  'Landscape',
];

class Gallery extends StatefulWidget {
  const Gallery({super.key});
  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  String category = 'All', query = '';
  bool reverse = false;
  @override
  Widget build(BuildContext c) {
    var ids = List.generate(8, (i) => i)
        .where(
          (i) =>
              (category == 'All' || cats[i] == category) &&
              ('${titles[i]} ${cats[i]} nature travel'.toLowerCase().contains(
                query.toLowerCase(),
              )),
        )
        .toList();
    if (reverse) ids = ids.reversed.toList();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1260),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                'THE IMAGE GALLERY',
                'A little visual escape.',
                'A collection of landscapes, light, and places worth lingering over.',
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final cat in ['All', 'Mountains', 'Forest', 'Landscape'])
                    ChoiceChip(
                      label: Text(cat),
                      selected: category == cat,
                      onSelected: (_) => setState(() => category = cat),
                    ),
                  SizedBox(
                    width: 230,
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search images',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => setState(() => query = v),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => reverse = !reverse),
                    icon: const Icon(Icons.sort),
                    label: Text(reverse ? 'Reverse order' : 'Original order'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (ids.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('No images found. Try another search.'),
                )
              else
                LayoutBuilder(
                  builder: (c, b) {
                    final n = b.maxWidth > 900
                        ? 3
                        : b.maxWidth > 560
                        ? 2
                        : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ids.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: n,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 22,
                        childAspectRatio: 1.05,
                      ),
                      itemBuilder: (c, index) {
                        final i = ids[index];
                        return InkWell(
                          onTap: () => Navigator.of(c).push(
                            MaterialPageRoute(
                              builder: (_) => Viewer(ids: ids, initial: index),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Image.asset(
                                    'assets/images/$i.jpg',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                titles[i],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${cats[i]}  ·  Nature',
                                style: const TextStyle(
                                  color: muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class Viewer extends StatefulWidget {
  final List<int> ids;
  final int initial;
  const Viewer({super.key, required this.ids, required this.initial});
  @override
  State<Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  late int current;
  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  void step(int d) => setState(
    () => current = (current + d + widget.ids.length) % widget.ids.length,
  );
  @override
  Widget build(BuildContext c) {
    final i = widget.ids[current];
    return Scaffold(
      backgroundColor: ink,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '${titles[i]}  /  ${current + 1} of ${widget.ids.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(c),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => step(-1),
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                  ),
                  Expanded(
                    child: InteractiveViewer(
                      key: ValueKey(i),
                      minScale: 1,
                      maxScale: 5,
                      child: Center(
                        child: Image.asset(
                          'assets/images/$i.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => step(1),
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  for (var j = 0; j < widget.ids.length; j++)
                    GestureDetector(
                      onTap: () => setState(() => current = j),
                      child: Container(
                        width: 78,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: j == current ? accent : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/${widget.ids[j]}.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Stroke {
  List<Offset> points;
  Color color;
  double width;
  Offset offset;
  Stroke(this.points, this.color, this.width, {this.offset = Offset.zero});
}

class GraphicPad extends StatefulWidget {
  const GraphicPad({super.key});
  @override
  State<GraphicPad> createState() => _GraphicPadState();
}

class _GraphicPadState extends State<GraphicPad> {
  final strokes = <Stroke>[];
  Stroke? active;
  int? selected;
  bool select = false;
  Color color = ink;
  double width = 3, zoom = 1;
  Offset pan = Offset.zero, last = Offset.zero;
  Offset world(Offset p) => (p - pan) / zoom;
  @override
  Widget build(BuildContext c) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const SizedBox(width: 8),
            const Text(
              'GRAPHICPAD',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            const SizedBox(width: 12),
            ChoiceChip(
              label: const Text('Pen'),
              selected: !select,
              onSelected: (_) => setState(() => select = false),
            ),
            ChoiceChip(
              label: const Text('Select / move'),
              selected: select,
              onSelected: (_) => setState(() => select = true),
            ),
            for (final col in [
              ink,
              const Color(0xffdf755b),
              const Color(0xff668e81),
              const Color(0xffc1a84d),
            ])
              InkWell(
                onTap: () => setState(() => color = col),
                child: Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    color: col,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color == col ? Colors.black : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: 110,
              child: Slider(
                value: width,
                min: 1,
                max: 14,
                onChanged: (v) => setState(() => width = v),
              ),
            ),
            IconButton(
              tooltip: 'Undo last stroke',
              onPressed: () => setState(() {
                if (strokes.isNotEmpty) strokes.removeLast();
                selected = null;
              }),
              icon: const Icon(Icons.undo),
            ),
            IconButton(
              tooltip: 'Delete selection',
              onPressed: () => setState(() {
                if (selected != null) {
                  strokes.removeAt(selected!);
                  selected = null;
                }
              }),
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              tooltip: 'Zoom out',
              onPressed: () => setState(() => zoom = (zoom / 1.2).clamp(.3, 4)),
              icon: const Icon(Icons.remove),
            ),
            Text('${(zoom * 100).round()}%'),
            IconButton(
              tooltip: 'Zoom in',
              onPressed: () => setState(() => zoom = (zoom * 1.2).clamp(.3, 4)),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              tooltip: 'Reset view',
              onPressed: () => setState(() {
                zoom = 1;
                pan = Offset.zero;
              }),
              icon: const Icon(Icons.center_focus_strong),
            ),
            const Text(
              'Scroll to zoom · middle drag to pan',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ],
        ),
      ),
      Expanded(
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.delete ||
                    event.logicalKey == LogicalKeyboardKey.backspace) &&
                selected != null) {
              setState(() {
                strokes.removeAt(selected!);
                selected = null;
              });
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Listener(
            onPointerSignal: (e) {
              if (e is PointerScrollEvent) {
                setState(
                  () => zoom = (zoom * (e.scrollDelta.dy > 0 ? .9 : 1.1)).clamp(
                    .3,
                    4,
                  ),
                );
              }
            },
            onPointerDown: (e) {
              last = e.localPosition;
              if (e.buttons == kMiddleMouseButton) return;
              final p = world(e.localPosition);
              setState(() {
                if (select) {
                  selected = null;
                  for (var i = strokes.length - 1; i >= 0; i--) {
                    if (strokes[i].points.any(
                      (q) => (q + strokes[i].offset - p).distance < 12 / zoom,
                    )) {
                      selected = i;
                      break;
                    }
                  }
                } else {
                  active = Stroke(
                    [p],
                    color,
                    width *
                        (e.pressureMin < e.pressureMax
                            ? (.4 + e.pressure * .6)
                            : 1),
                  );
                  strokes.add(active!);
                }
              });
            },
            onPointerMove: (e) {
              setState(() {
                if (e.buttons == kMiddleMouseButton) {
                  pan += e.localPosition - last;
                } else if (select && selected != null) {
                  strokes[selected!].offset += (e.localPosition - last) / zoom;
                } else if (active != null) {
                  active!.points.add(world(e.localPosition));
                }
                last = e.localPosition;
              });
            },
            onPointerUp: (_) => active = null,
            child: CustomPaint(
              painter: DrawingPainter(strokes, selected, zoom, pan),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    ],
  );
}

class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;
  final int? selected;
  final double zoom;
  final Offset pan;
  DrawingPainter(this.strokes, this.selected, this.zoom, this.pan);
  @override
  void paint(Canvas c, Size size) {
    c.drawColor(const Color(0xffe9ece6), BlendMode.src);
    final grid = Paint()
      ..color = const Color(0xffdce1d9)
      ..strokeWidth = 1;
    for (double x = pan.dx % (32 * zoom); x < size.width; x += 32 * zoom) {
      c.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = pan.dy % (32 * zoom); y < size.height; y += 32 * zoom) {
      c.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    c.translate(pan.dx, pan.dy);
    c.scale(zoom);
    for (var i = 0; i < strokes.length; i++) {
      final s = strokes[i];
      if (s.points.isEmpty) continue;
      final p = Path()
        ..moveTo(
          s.points.first.dx + s.offset.dx,
          s.points.first.dy + s.offset.dy,
        );
      for (var j = 1; j < s.points.length; j++) {
        final a = s.points[j - 1] + s.offset, b = s.points[j] + s.offset;
        p.quadraticBezierTo(a.dx, a.dy, (a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
      }
      if (s.points.length == 1) {
        p.lineTo(
          s.points.first.dx + s.offset.dx + .01,
          s.points.first.dy + s.offset.dy,
        );
      }
      c.drawPath(
        p,
        Paint()
          ..color = s.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = s.width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      if (i == selected) {
        final bounds = p.getBounds().inflate(7);
        c.drawRect(
          bounds,
          Paint()
            ..color = Colors.blueAccent
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1 / zoom,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter old) => true;
}

class Architecture extends StatefulWidget {
  const Architecture({super.key});
  @override
  State<Architecture> createState() => _ArchitectureState();
}

class _ArchitectureState extends State<Architecture> {
  scene.Scene? model;
  double w = 4, d = 3, h = 3, angle = .8, elevation = .45, distance = 11;
  Offset last = Offset.zero;
  int material = 0;
  @override
  void initState() {
    super.initState();
    scene.Scene.initializeStaticResources().then((_) {
      if (mounted) regenerate();
    });
  }

  void regenerate() {
    final s = scene.Scene();
    void box(
      double x,
      double y,
      double z,
      double sx,
      double sy,
      double sz,
      vm.Vector4 col,
    ) {
      final mat = scene.PhysicallyBasedMaterial()
        ..baseColorFactor = col
        ..roughnessFactor = .75;
      final node = scene.Node(
        mesh: scene.Mesh(scene.CuboidGeometry(vm.Vector3(sx, sy, sz)), mat),
      )..position = vm.Vector3(x, y, z);
      s.add(node);
    }

    final wall = material == 0
        ? vm.Vector4(.75, .73, .65, 1)
        : vm.Vector4(.34, .43, .39, 1);
    final dark = vm.Vector4(.17, .22, .21, 1);
    box(0, -.12, 0, w + 1, .24, d + 1, vm.Vector4(.43, .46, .4, 1));
    box(0, h / 2, 0, w, h, d, wall);
    box(0, h + .12, 0, w + .35, .24, d + .35, dark);
    for (var i = 0; i < 3; i++) {
      box(
        -w * .3 + i * w * .3,
        h * .58,
        -d / 2 - .015,
        w * .18,
        h * .42,
        .04,
        dark,
      );
    }
    box(
      0,
      h * .25,
      -d / 2 - .04,
      w * .18,
      h * .5,
      .08,
      vm.Vector4(.28, .2, .14, 1),
    );
    setState(() => model = s);
  }

  Widget slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> change,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(label),
          const Spacer(),
          Text(
            '${value.toStringAsFixed(1)} m',
            style: const TextStyle(color: muted),
          ),
        ],
      ),
      Slider(
        value: value,
        min: min,
        max: max,
        onChanged: (v) {
          change(v);
          regenerate();
        },
      ),
    ],
  );
  @override
  Widget build(BuildContext c) {
    final controls = Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: [
          const Tag('PARAMETRIC STUDY'),
          const SizedBox(height: 12),
          const Text(
            'The pavilion',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adjust the dimensions to reshape the model.',
            style: TextStyle(color: muted, height: 1.4),
          ),
          const SizedBox(height: 25),
          slider('Width', w, 2, 7, (v) => w = v),
          slider('Depth', d, 2, 6, (v) => d = v),
          slider('Height', h, 2, 6, (v) => h = v),
          const SizedBox(height: 15),
          const Text(
            'MATERIAL',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Limestone'),
                selected: material == 0,
                onSelected: (_) {
                  material = 0;
                  regenerate();
                },
              ),
              ChoiceChip(
                label: const Text('Sage'),
                selected: material == 1,
                onSelected: (_) {
                  material = 1;
                  regenerate();
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Drag to orbit · scroll to zoom',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    );
    final viewport = Container(
      color: const Color(0xffdce3d9),
      child: Listener(
        onPointerSignal: (e) {
          if (e is PointerScrollEvent) {
            setState(
              () => distance = (distance + e.scrollDelta.dy * .01).clamp(4, 25),
            );
          }
        },
        onPointerDown: (e) => last = e.localPosition,
        onPointerMove: (e) {
          final delta = e.localPosition - last;
          last = e.localPosition;
          setState(() {
            angle += delta.dx * .01;
            elevation = (elevation + delta.dy * .01).clamp(-1.2, 1.2);
          });
        },
        child: model == null
            ? const Center(child: CircularProgressIndicator())
            : scene.SceneView(
                model!,
                camera: scene.PerspectiveCamera(
                  position: vm.Vector3(
                    math.sin(angle) * math.cos(elevation) * distance,
                    math.sin(elevation) * distance + 1,
                    math.cos(angle) * math.cos(elevation) * distance,
                  ),
                  target: vm.Vector3(0, 1, 0),
                ),
              ),
      ),
    );
    return LayoutBuilder(
      builder: (c, b) => b.maxWidth > 700
          ? Row(
              children: [
                controls,
                Expanded(child: viewport),
              ],
            )
          : Column(
              children: [
                Expanded(child: viewport),
                SizedBox(height: 220, child: controls),
              ],
            ),
    );
  }
}
