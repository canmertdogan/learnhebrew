import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'data.dart';
import 'store.dart';
import 'theme.dart';

class StudyHome extends StatelessWidget {
  final Category category;
  const StudyHome({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (category) {
            Category.words => 'אוֹצַר מִלִּים · Book of 1,000 Words',
            Category.verbs => 'סֵפֶר הַפְּעָלִים · Codex of 1,000 Verbs',
            Category.sentences => 'שִׂיחוֹת יוֹם־יוֹם · Scroll of 100 Colloquies',
          },
          style: const TextStyle(fontSize: 18, color: AncientPalette.goldBright),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(padding: const EdgeInsets.all(20), children: [
            _parchmentMode(
              context,
              '📜',
              'Illuminated Flashcards',
              'Turn parchment folios and seal mastered words into your memory',
              (e) => FlashcardPage(category: category, entries: e),
            ),
            _parchmentMode(
              context,
              '⚖️',
              'Scribe’s Trial (Quiz)',
              'Test your discernment between sacred text and translation',
              (e) => QuizPage(category: category, entries: e),
            ),
            _parchmentMode(
              context,
              '📖',
              'Complete Lexicon (Browse)',
              'Inspect and search all ancient entries with audio pronunciation',
              (e) => BrowsePage(category: category, entries: e),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _parchmentMode(BuildContext context, String icon, String t, String s,
      Widget Function(List<Entry>) page) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AncientPalette.parchmentBox(),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Text(icon, style: const TextStyle(fontSize: 32)),
          title: Text(t,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: AncientPalette.inkDeep)),
          subtitle: Text(s, style: const TextStyle(color: AncientPalette.inkFaded, fontSize: 13)),
          trailing: const Icon(Icons.chevron_right, color: AncientPalette.inkDeep),
          onTap: () async {
            final entries = await Data.load(category);
            if (!context.mounted) return;
            Navigator.push(context, MaterialPageRoute(builder: (_) => page(entries)));
          },
        ),
      ),
    );
  }
}

class HebrewText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const HebrewText(this.text, {super.key, this.size = 36, this.color = AncientPalette.inkDeep});
  @override
  Widget build(BuildContext context) => Text(
        text,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
          height: 1.45,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      );
}

class BrowsePage extends StatefulWidget {
  final Category category;
  final List<Entry> entries;
  const BrowsePage({super.key, required this.category, required this.entries});
  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final ql = q.toLowerCase();
    final plainQ = q.replaceAll(RegExp('[\u0591-\u05C7]'), '');
    final list = widget.entries
        .where((e) =>
            ql.isEmpty ||
            e.english.toLowerCase().contains(ql) ||
            e.translit.toLowerCase().contains(ql) ||
            e.hebrew.contains(q) ||
            e.hebrew.replaceAll(RegExp('[\u0591-\u05C7]'), '').contains(plainQ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category.title} (${list.length})',
            style: const TextStyle(color: AncientPalette.goldBright)),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            style: const TextStyle(color: AncientPalette.inkDeep),
            decoration: InputDecoration(
              filled: true,
              fillColor: AncientPalette.parchmentLight,
              prefixIcon: const Icon(Icons.search, color: AncientPalette.inkBrown),
              hintText: 'Search by English, transliteration, or Hebrew...',
              hintStyle: const TextStyle(color: AncientPalette.inkFaded, fontStyle: FontStyle.italic),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AncientPalette.goldBronze, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AncientPalette.goldBronze, width: 2),
              ),
            ),
            onChanged: (v) => setState(() => q = v),
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: Store.i,
            builder: (context, _) => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final e = list[i];
                final known = Store.i.isKnown(e.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AncientPalette.parchmentLight, AncientPalette.parchmentMid],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AncientPalette.goldBronze, width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      activeColor: AncientPalette.crimsonWax,
                      value: known,
                      onChanged: (v) => Store.i.setKnown(e.id, v ?? false),
                    ),
                    title: Text(e.english,
                        style: const TextStyle(
                            color: AncientPalette.inkDeep, fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Store.i.showTranslit
                        ? Text(
                            '“${e.translit}”${e.extra != null ? ' • Present: ${e.extra}' : ''}',
                            style: const TextStyle(
                                color: AncientPalette.crimsonWax, fontStyle: FontStyle.italic))
                        : null,
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Flexible(
                        child: Text(
                          e.hebrew,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600, color: AncientPalette.inkDeep),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: AncientPalette.crimsonWax),
                        onPressed: () => Store.i.speak(e.hebrew),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}

class FlashcardPage extends StatefulWidget {
  final Category category;
  final List<Entry> entries;
  const FlashcardPage({super.key, required this.category, required this.entries});
  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  late List<Entry> deck;
  int i = 0;
  bool flipped = false;
  bool hebrewFirst = true;

  @override
  void initState() {
    super.initState();
    _build();
  }

  void _build() {
    deck = [
      ...widget.entries.where((e) => !Store.i.isKnown(e.id)),
    ];
    i = 0;
    flipped = false;
  }

  void _next(bool known) {
    final e = deck[i];
    Store.i.setKnown(e.id, known);
    setState(() {
      flipped = false;
      if (i < deck.length - 1) {
        i++;
      } else {
        deck = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (deck.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scroll Cards')),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: AncientPalette.parchmentBox(),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('❖ All Scrolls Mastered ❖',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AncientPalette.inkDeep)),
              const SizedBox(height: 12),
              const Text('You have sealed every entry in this codex into your memory.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AncientPalette.inkFaded, fontStyle: FontStyle.italic)),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AncientPalette.crimsonWax),
                onPressed: () => setState(_build),
                child: const Text('Unroll Codex Again'),
              ),
            ]),
          ),
        ),
      );
    }
    final e = deck[i];
    final heb = Column(mainAxisSize: MainAxisSize.min, children: [
      HebrewText(e.hebrew, size: widget.category == Category.sentences ? 28 : 52),
      Text(
        e.hebrew.replaceAll(RegExp('[\u0591-\u05C7]'), ''),
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontFamily: 'Cursive',
          fontSize: 32,
          color: AncientPalette.crimsonWax,
        ),
      ),
      if (e.extra != null) ...[
        const SizedBox(height: 6),
        Text('Present: ${e.extra}',
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 20, color: AncientPalette.inkFaded)),
      ],
    ]);
    final eng = Column(mainAxisSize: MainAxisSize.min, children: [
      Text(e.english,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AncientPalette.inkDeep)),
      if (Store.i.showTranslit) ...[
        const SizedBox(height: 6),
        Text('“${e.translit}”',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: AncientPalette.crimsonWax)),
      ],
    ]);
    final front = hebrewFirst ? heb : eng;
    final back = hebrewFirst ? eng : heb;
    return Scaffold(
      appBar: AppBar(
        title: Text('Folio ${i + 1} of ${deck.length}',
            style: const TextStyle(color: AncientPalette.goldBright)),
        actions: [
          IconButton(
              tooltip: 'Reverse scroll face',
              icon: const Icon(Icons.swap_horiz, color: AncientPalette.goldBright),
              onPressed: () => setState(() {
                    hebrewFirst = !hebrewFirst;
                    flipped = false;
                  })),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Expanded(
                child: Container(
                  decoration: AncientPalette.parchmentBox(radius: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => setState(() => flipped = !flipped),
                      child: Stack(children: [
                        Center(
                            child: Padding(
                                padding: const EdgeInsets.all(28),
                                child: flipped ? back : front)),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                              icon: const Icon(Icons.volume_up, color: AncientPalette.crimsonWax, size: 28),
                              onPressed: () => Store.i.speak(e.hebrew)),
                        ),
                        const Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Text(
                            '✦ Touch to turn scroll ✦',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: AncientPalette.inkFaded,
                              letterSpacing: 1.5,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AncientPalette.parchmentLight,
                      side: const BorderSide(color: AncientPalette.goldBronze, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => _next(false),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Keep in Study Pile'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AncientPalette.crimsonWax,
                      foregroundColor: AncientPalette.parchmentLight,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => _next(true),
                    icon: const Icon(Icons.check),
                    label: const Text('Seal as Mastered'),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final Category category;
  final List<Entry> entries;
  const QuizPage({super.key, required this.category, required this.entries});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final rnd = math.Random();
  late Entry target;
  late List<Entry> options;
  late bool askHebrew;
  int? picked;
  int score = 0, total = 0;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    final all = widget.entries;
    final pool = all.where((e) => !Store.i.isKnown(e.id)).toList();
    target = (pool.isEmpty ? all : pool)[rnd.nextInt((pool.isEmpty ? all : pool).length)];
    final opts = <Entry>{target};
    while (opts.length < 4) {
      opts.add(all[rnd.nextInt(all.length)]);
    }
    options = opts.toList()..shuffle(rnd);
    askHebrew = rnd.nextBool();
    picked = null;
  }

  @override
  Widget build(BuildContext context) {
    final sentence = widget.category == Category.sentences;
    return Scaffold(
      appBar: AppBar(
        title: Text('Scribe’s Trial · Score: $score / $total',
            style: const TextStyle(color: AncientPalette.goldBright)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: AncientPalette.parchmentBox(radius: 8),
              child: Column(children: [
                askHebrew
                    ? HebrewText(target.hebrew, size: sentence ? 26 : 46)
                    : Text(target.english,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold, color: AncientPalette.inkDeep)),
                if (askHebrew) ...[
                  const SizedBox(height: 8),
                  IconButton(
                      icon: const Icon(Icons.volume_up, color: AncientPalette.crimsonWax, size: 28),
                      onPressed: () => Store.i.speak(target.hebrew)),
                ],
              ]),
            ),
            const SizedBox(height: 16),
            for (var k = 0; k < options.length; k++) _option(k, sentence),
            if (picked != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AncientPalette.crimsonWax,
                      foregroundColor: AncientPalette.parchmentLight,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => setState(_newQuestion),
                    child: const Text('Next Trial →', style: TextStyle(fontSize: 16))),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _option(int k, bool sentence) {
    final o = options[k];
    Color bg1 = AncientPalette.parchmentLight;
    Color bg2 = AncientPalette.parchmentMid;
    Color border = AncientPalette.goldBronze;

    if (picked != null) {
      if (o == target) {
        bg1 = const Color(0xFFCCE3C6);
        bg2 = const Color(0xFFA5CCA0);
        border = const Color(0xFF2E6F28);
      } else if (picked == k) {
        bg1 = const Color(0xFFE8C2BE);
        bg2 = const Color(0xFFD49B94);
        border = AncientPalette.crimsonWax;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [bg1, bg2]),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ListTile(
        title: askHebrew
            ? Text(o.english,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AncientPalette.inkDeep, fontWeight: FontWeight.bold, fontSize: 16))
            : HebrewText(o.hebrew, size: sentence ? 20 : 28),
        subtitle: !askHebrew && Store.i.showTranslit && picked != null
            ? Text('“${o.translit}”',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AncientPalette.crimsonWax, fontStyle: FontStyle.italic))
            : null,
        onTap: picked != null
            ? null
            : () {
                setState(() {
                  picked = k;
                  total++;
                  if (o == target) {
                    score++;
                    Store.i.setKnown(target.id, true);
                    Store.i.speak(target.hebrew);
                  } else {
                    Store.i.setKnown(target.id, false);
                  }
                });
              },
      ),
    );
  }
}
