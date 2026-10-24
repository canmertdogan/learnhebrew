import 'package:flutter/material.dart';
import 'data.dart';
import 'handwriting.dart';
import 'store.dart';
import 'study.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.i.init();
  runApp(const HebrewApp());
}

class HebrewApp extends StatelessWidget {
  const HebrewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AncientPalette.obsidian,
      fontFamily: 'Georgia',
      colorScheme: const ColorScheme.dark(
        primary: AncientPalette.goldBright,
        secondary: AncientPalette.crimsonWax,
        surface: AncientPalette.wood,
        onPrimary: AncientPalette.inkDeep,
        onSurface: AncientPalette.parchmentLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AncientPalette.wood,
        foregroundColor: AncientPalette.goldBright,
        elevation: 4,
        centerTitle: false,
      ),
    );
    return MaterialApp(
      title: 'בֵּית הַמִּדְרָשׁ · Ancient Hebrew Scriptorium',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const totals = {
    Category.words: 1000,
    Category.verbs: 1000,
    Category.sentences: 100,
  };
  static const seals = {
    Category.words: 'א',
    Category.verbs: 'פ',
    Category.sentences: 'ש',
  };
  static const hebTitles = {
    Category.words: 'אוֹצַר מִלִּים',
    Category.verbs: 'סֵפֶר הַפְּעָלִים',
    Category.sentences: 'שִׂיחוֹת יוֹם־יוֹם',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('בֵּית הַמִּדְרָשׁ לְעִבְרִית',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AncientPalette.goldBright)),
            Text('ANCIENT HEBREW SCRIPTORIUM',
                style: TextStyle(fontSize: 10, letterSpacing: 2.2, color: AncientPalette.parchmentDark)),
          ],
        ),
        actions: [
          ListenableBuilder(
            listenable: Store.i,
            builder: (_, __) => Row(children: [
              const Text('Translit.', style: TextStyle(fontSize: 12, color: AncientPalette.parchmentMid)),
              Switch(
                  activeColor: AncientPalette.goldBright,
                  value: Store.i.showTranslit,
                  onChanged: Store.i.setTranslit),
              const SizedBox(width: 8),
            ]),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListenableBuilder(
            listenable: Store.i,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: AncientPalette.goldBronze, width: 1),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text('✦ ❖ ✦', style: TextStyle(color: AncientPalette.goldBright, letterSpacing: 6)),
                      SizedBox(height: 6),
                      Text('שָׁלוֹם עֲלֵיכֶם · The Sacred & Living Tongue',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AncientPalette.parchmentLight)),
                      SizedBox(height: 4),
                      Text(
                        'Select an illuminated parchment codex below to study vocabulary, conjugations, colloquies, or cursive scribe handwriting.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontStyle: FontStyle.italic, color: AncientPalette.parchmentDark),
                      ),
                    ],
                  ),
                ),
                for (final c in Category.values)
                  _parchmentTile(
                    context,
                    seal: seals[c]!,
                    hebTitle: hebTitles[c]!,
                    title: c.title,
                    subtitle: c.subtitle,
                    progress: Store.i.knownCount('${c.name}:') / totals[c]!,
                    trailing: '${Store.i.knownCount('${c.name}:')}/${totals[c]} Mastered',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => StudyHome(category: c))),
                  ),
                _parchmentTile(
                  context,
                  seal: 'כ',
                  hebTitle: 'כְּתַב יָד רָהוּט',
                  title: 'Scribe’s Cursive Studio',
                  subtitle: 'Trace all 27 Hebrew letters & classic words on vellum with reed-ink strokes',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HandwritingHome())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _parchmentTile(BuildContext context,
      {required String seal,
      required String hebTitle,
      required String title,
      required String subtitle,
      double? progress,
      String? trailing,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AncientPalette.parchmentBox(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AncientPalette.crimsonWax,
                    border: Border.all(color: AncientPalette.goldBright, width: 1.5),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3))],
                  ),
                  child: Text(seal,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold, color: AncientPalette.parchmentLight)),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(hebTitle,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AncientPalette.crimsonWax)),
                          if (trailing != null)
                            Text(trailing,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AncientPalette.inkFaded)),
                        ],
                      ),
                      Text(title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: AncientPalette.inkDeep)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(color: AncientPalette.inkFaded, fontSize: 14)),
                      if (progress != null) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: Colors.black12,
                            valueColor: const AlwaysStoppedAnimation<Color>(AncientPalette.crimsonWax),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AncientPalette.inkDeep),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
