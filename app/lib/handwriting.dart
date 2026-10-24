import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'store.dart';
import 'theme.dart';

class Glyph {
  final String text, name, print, tip;
  const Glyph(this.text, this.name, this.print, this.tip);
}

const letters = <Glyph>[
  Glyph('א', 'Alef', 'silent / glottal', 'Begin with the right-hand curved bow (like a crescent), then draw the vertical-left stroke beside it.'),
  Glyph('ב', 'Bet', 'b / v', 'A single flowing arch from the top, curving along the baseline with a small tail.'),
  Glyph('ג', 'Gimel', 'g', 'A graceful downward curve with a small foot kicking out to the left at the base.'),
  Glyph('ד', 'Dalet', 'd', 'A rounded loop at the base rising into an oblique tail on the right — distinct from Resh.'),
  Glyph('ה', 'He', 'h', 'Draw the broad outer arch right-to-left, then place the small detached stroke inside at the bottom-left.'),
  Glyph('ו', 'Vav', 'v / o / u', 'A single upright reed stroke down to the baseline.'),
  Glyph('ז', 'Zayin', 'z', 'Crown with a small upper loop and sweep downwards.'),
  Glyph('ח', 'Het', 'kh (guttural h)', 'Draw the outer arch, keeping the left leg connected to the roof.'),
  Glyph('ט', 'Tet', 't', 'Sweep down from the left and curve around in a deep open bowl.'),
  Glyph('י', 'Yod', 'y / i', 'The smallest letter: a quick suspended drop near the top guideline.'),
  Glyph('כ', 'Kaf', 'k / kh', 'A smooth rounded crescent opening toward the left.'),
  Glyph('ך', 'Final Kaf', 'kh (end of word)', 'Small top hook descending in a long scribe’s tail below the baseline.'),
  Glyph('ל', 'Lamed', 'l', 'Loop on the baseline and ascend high above the upper line.'),
  Glyph('מ', 'Mem', 'm', 'Written right-to-left like a flowing two-peaked arch.'),
  Glyph('ם', 'Final Mem', 'm (end of word)', 'A closed circular loop finished with a short downward stroke on the left.'),
  Glyph('נ', 'Nun', 'n', 'Descend and turn slightly onto the baseline.'),
  Glyph('ן', 'Final Nun', 'n (end of word)', 'A long vertical shaft extending well below the baseline.'),
  Glyph('ס', 'Samekh', 's', 'A complete continuous ring.'),
  Glyph('ע', 'Ayin', 'silent / guttural', 'Sweep down from the right, loop at the base, and rise up to the left.'),
  Glyph('פ', 'Pe', 'p / f', 'Start from the inner curl and spiral outward around the top to the base.'),
  Glyph('ף', 'Final Pe', 'f (end of word)', 'Loop high at the top and draw the long stem below the baseline.'),
  Glyph('צ', 'Tsadi', 'ts', 'Shaped like a scripted figure 3 facing left.'),
  Glyph('ץ', 'Final Tsadi', 'ts (end of word)', 'Rise and cross into a tall loop with a long descender.'),
  Glyph('ק', 'Qof', 'k', 'Upper curved head first, then the vertical shaft descending below the line.'),
  Glyph('ר', 'Resh', 'r', 'A gentle single curved arch without corners.'),
  Glyph('ש', 'Shin', 'sh / s', 'A wide outer cup with a small inner loop on the left.'),
  Glyph('ת', 'Tav', 't', 'Draw the right-hand arch, then add the left leg curving outward at the foot.'),
];

const practiceWords = <Glyph>[
  Glyph('שלום', 'shalom', 'peace / hello', 'Write right to left: Shin (ש), Lamed (ל), Vav (ו), Final Mem (ם).'),
  Glyph('תודה', 'toda', 'gratitude / thank you', 'Right to left: Tav (ת), Vav (ו), Dalet (ד), He (ה).'),
  Glyph('בבקשה', 'bevakasha', 'please / you are welcome', 'Right to left: Bet, Bet, Qof, Shin, He.'),
  Glyph('אהבה', 'ahava', 'love', 'Right to left: Alef, He, Bet, He.'),
  Glyph('חכמה', 'chokhma', 'wisdom', 'Right to left: Het, Kaf, Mem, He.'),
  Glyph('אמת', 'emet', 'truth', 'Right to left: Alef, Mem, Tav.'),
  Glyph('חיים', 'chayim', 'life', 'Right to left: Het, Yod, Yod, Final Mem.'),
  Glyph('שמש', 'shemesh', 'sun', 'Right to left: Shin, Mem, Shin.'),
  Glyph('מים', 'mayim', 'water', 'Right to left: Mem, Yod, Final Mem.'),
  Glyph('לחם', 'lechem', 'bread', 'Right to left: Lamed, Het, Final Mem.'),
  Glyph('ספר', 'sefer', 'scroll / book', 'Right to left: Samekh, Pe, Resh.'),
  Glyph('בית', 'bayit', 'house', 'Right to left: Bet, Yod, Tav.'),
  Glyph('חבר', 'chaver', 'friend / companion', 'Right to left: Het, Bet, Resh.'),
  Glyph('בוקר טוב', 'boker tov', 'good morning', 'Two words written right to left; leave a space between them.'),
  Glyph('ערב טוב', 'erev tov', 'good evening', 'Two words written right to left.'),
  Glyph('לילה טוב', 'laila tov', 'good night', 'Two words written right to left.'),
];

class HandwritingHome extends StatelessWidget {
  const HandwritingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('כְּתַב יָד · Scribe’s Cursive Studio',
              style: TextStyle(color: AncientPalette.goldBright)),
          bottom: const TabBar(
            indicatorColor: AncientPalette.crimsonWax,
            labelColor: AncientPalette.goldBright,
            unselectedLabelColor: AncientPalette.parchmentDark,
            tabs: [
              Tab(text: '27 Sacred Letters'),
              Tab(text: 'Illuminated Words'),
            ],
          ),
        ),
        body: const TabBarView(children: [
          _GlyphGrid(items: letters, big: true),
          _GlyphGrid(items: practiceWords, big: false),
        ]),
      ),
    );
  }
}

class _GlyphGrid extends StatelessWidget {
  final List<Glyph> items;
  final bool big;
  const _GlyphGrid({required this.items, required this.big});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Store.i,
      builder: (context, _) => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: big ? 160 : 230,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: big ? 0.92 : 1.35),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final g = items[i];
          final stars = Store.i.stars(g.text);
          return Container(
            decoration: AncientPalette.parchmentBox(radius: 6),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TracePage(items: items, index: i))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            g.text,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Cursive',
                              fontSize: big ? 60 : 36,
                              color: AncientPalette.inkDeep,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Block: ${g.text}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: AncientPalette.crimsonWax,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        g.name,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AncientPalette.inkDeep),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (k) => Icon(
                            k < stars ? Icons.star : Icons.star_border,
                            size: 15,
                            color: AncientPalette.goldBronze,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TracePage extends StatefulWidget {
  final List<Glyph> items;
  final int index;
  const TracePage({super.key, required this.items, required this.index});

  @override
  State<TracePage> createState() => _TracePageState();
}

class _TracePageState extends State<TracePage> {
  late int index = widget.index;
  final List<List<Offset>> strokes = [];
  bool ghost = true;
  String? feedback;
  Size canvasSize = const Size(320, 320);

  Glyph get g => widget.items[index];

  void go(int d) {
    final n = index + d;
    if (n < 0 || n >= widget.items.length) return;
    setState(() {
      index = n;
      strokes.clear();
      feedback = null;
    });
  }

  Future<void> check() async {
    final score = await scoreTrace(g.text, strokes, canvasSize);
    final stars = score >= 0.65 ? 3 : score >= 0.45 ? 2 : score >= 0.25 ? 1 : 0;
    Store.i.setStars(g.text, stars);
    setState(() {
      feedback = switch (stars) {
        3 => '✦ Master Scribe! Worthy of the ancient scrolls (${(score * 100).round()}%).',
        2 => '✦ Well-formed hand! Steady your reed along the curve (${(score * 100).round()}%).',
        1 => '✦ Apprentice mark — trace closer over the stencil (${(score * 100).round()}%).',
        _ => '✦ Keep the Stencil ON and guide your pen directly over the glyph.',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final big = g.text.length == 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('${g.name} · ${g.print}',
            style: const TextStyle(color: AncientPalette.goldBright)),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: AncientPalette.goldBright),
            onPressed: () => Store.i.speak(g.text),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                  child: Text(
                    g.tip,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: AncientPalette.parchmentMid),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(builder: (context, c) {
                      final side = big
                          ? math.min(c.maxWidth, c.maxHeight)
                          : c.maxWidth;
                      final h = big ? side : math.min(c.maxHeight, side * 0.58);
                      canvasSize = Size(side, h);
                      return Center(
                        child: Container(
                          width: side,
                          height: h,
                          decoration: BoxDecoration(
                            gradient: const RadialGradient(
                              center: Alignment.center,
                              radius: 1.0,
                              colors: [
                                Color(0xFFFBF3E3),
                                Color(0xFFEDDAB8),
                                Color(0xFFD8BE92)
                              ],
                            ),
                            border: Border.all(color: AncientPalette.woodBorder, width: 3),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(color: Colors.black87, blurRadius: 18, offset: Offset(0, 8)),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: GestureDetector(
                              onPanStart: (d) => setState(() {
                                strokes.add([d.localPosition]);
                                feedback = null;
                              }),
                              onPanUpdate: (d) => setState(
                                  () => strokes.last.add(d.localPosition)),
                              child: CustomPaint(
                                painter: _TracePainter(
                                    g.text, strokes, ghost, Size(side, h)),
                                size: Size(side, h),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                if (feedback != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(
                      feedback!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AncientPalette.goldBright),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      IconButton.outlined(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AncientPalette.goldBronze)),
                          onPressed: index > 0 ? () => go(-1) : null,
                          icon: const Icon(Icons.chevron_left, color: AncientPalette.goldBright)),
                      OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AncientPalette.goldBronze),
                              foregroundColor: AncientPalette.parchmentLight),
                          onPressed: () => setState(() {
                                strokes.clear();
                                feedback = null;
                              }),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Wipe Vellum')),
                      OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AncientPalette.goldBronze),
                              foregroundColor: AncientPalette.parchmentLight),
                          onPressed: strokes.isEmpty
                              ? null
                              : () => setState(() => strokes.removeLast()),
                          icon: const Icon(Icons.undo),
                          label: const Text('Undo')),
                      FilterChip(
                          selectedColor: AncientPalette.woodBorder,
                          checkmarkColor: AncientPalette.goldBright,
                          label: Text(ghost ? 'Stencil: ON' : 'Stencil: OFF',
                              style: const TextStyle(color: AncientPalette.parchmentLight)),
                          selected: ghost,
                          onSelected: (v) => setState(() => ghost = v)),
                      FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AncientPalette.crimsonWax,
                            foregroundColor: AncientPalette.parchmentLight,
                          ),
                          onPressed: strokes.isEmpty ? null : check,
                          icon: const Icon(Icons.check),
                          label: const Text('Judge Script')),
                      IconButton.outlined(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AncientPalette.goldBronze)),
                          onPressed:
                              index < widget.items.length - 1 ? () => go(1) : null,
                          icon: const Icon(Icons.chevron_right, color: AncientPalette.goldBright)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TextPainter _ghostPainter(String text, Size size, Color color) {
  double fs = size.height * 0.75;
  late TextPainter tp;
  for (var i = 0; i < 8; i++) {
    tp = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(
              fontFamily: 'Cursive', fontSize: fs, color: color)),
      textDirection: TextDirection.rtl,
    )..layout();
    if (tp.width <= size.width * 0.88 && tp.height <= size.height * 0.92) break;
    fs *= 0.85;
  }
  return tp;
}

class _TracePainter extends CustomPainter {
  final String text;
  final List<List<Offset>> strokes;
  final bool ghost;
  final Size size0;
  _TracePainter(this.text, this.strokes, this.ghost, this.size0);

  @override
  void paint(Canvas canvas, Size size) {
    // Ruled scribe lines on vellum
    final guide = Paint()
      ..color = AncientPalette.crimsonWax.withValues(alpha: 0.22)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(20, size.height * 0.24),
        Offset(size.width - 20, size.height * 0.24), guide);
    canvas.drawLine(Offset(20, size.height * 0.76),
        Offset(size.width - 20, size.height * 0.76), guide);

    if (ghost) {
      final tp = _ghostPainter(
          text, size, AncientPalette.inkFaded.withValues(alpha: 0.32));
      tp.paint(canvas,
          Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
    }
    // Deep sepia iron-gall ink for strokes
    _paintStrokes(canvas, strokes, const Color(0xFF261409),
        size.shortestSide * 0.038);
  }

  @override
  bool shouldRepaint(covariant _TracePainter old) => true;
}

void _paintStrokes(
    Canvas canvas, List<List<Offset>> strokes, Color color, double width) {
  final p = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = width;
  for (final s in strokes) {
    if (s.length == 1) {
      canvas.drawCircle(s.first, width / 2, Paint()..color = color);
      continue;
    }
    final path = Path()..moveTo(s.first.dx, s.first.dy);
    for (final o in s.skip(1)) {
      path.lineTo(o.dx, o.dy);
    }
    canvas.drawPath(path, p);
  }
}

Future<double> scoreTrace(
    String text, List<List<Offset>> strokes, Size size) async {
  const n = 96;
  final sx = n / size.width, sy = n / size.height;

  Future<List<bool>> raster(void Function(Canvas) draw) async {
    final rec = ui.PictureRecorder();
    final c = Canvas(rec, Rect.fromLTWH(0, 0, n.toDouble(), n.toDouble()));
    draw(c);
    final img = await rec.endRecording().toImage(n, n);
    final bytes = (await img.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    return List.generate(n * n, (i) => bytes.getUint8(i * 4 + 3) > 40);
  }

  final ghostMask = await raster((c) {
    c.scale(sx, sy);
    final tp = _ghostPainter(text, size, Colors.black);
    tp.paint(
        c, Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
  });
  final userMask = await raster((c) {
    c.scale(sx, sy);
    _paintStrokes(c, strokes, Colors.black, size.shortestSide * 0.038);
  });

  List<bool> dilate(List<bool> m, int r) {
    final out = List<bool>.filled(n * n, false);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        if (!m[y * n + x]) continue;
        for (var dy = -r; dy <= r; dy++) {
          for (var dx = -r; dx <= r; dx++) {
            final yy = y + dy, xx = x + dx;
            if (yy >= 0 && yy < n && xx >= 0 && xx < n) out[yy * n + xx] = true;
          }
        }
      }
    }
    return out;
  }

  final userNear = dilate(userMask, 4);
  final ghostNear = dilate(ghostMask, 4);
  var g = 0, gHit = 0, u = 0, uHit = 0;
  for (var i = 0; i < n * n; i++) {
    if (ghostMask[i]) {
      g++;
      if (userNear[i]) gHit++;
    }
    if (userMask[i]) {
      u++;
      if (ghostNear[i]) uHit++;
    }
  }
  if (g == 0 || u == 0) return 0;
  final coverage = gHit / g, precision = uHit / u;
  return coverage * precision;
}
