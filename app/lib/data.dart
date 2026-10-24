import 'package:flutter/services.dart' show rootBundle;

enum Category { words, verbs, sentences }

extension CategoryInfo on Category {
  String get title => switch (this) {
        Category.words => 'Words',
        Category.verbs => 'Verbs',
        Category.sentences => 'Sentences',
      };
  String get subtitle => switch (this) {
        Category.words => '1000 common words',
        Category.verbs => '1000 common verbs',
        Category.sentences => '100 daily sentences',
      };
  List<String> get files => switch (this) {
        Category.words => ['words_1.tsv', 'words_2.tsv'],
        Category.verbs => ['verbs_1.tsv', 'verbs_2.tsv'],
        Category.sentences => ['sentences.tsv'],
      };
}

class Entry {
  final String id; // stable key: category + hebrew
  final String hebrew;
  final String translit;
  final String english;
  final String? extra; // verbs: present-tense masculine singular
  const Entry(this.id, this.hebrew, this.translit, this.english, [this.extra]);
}

class Data {
  static final Map<Category, List<Entry>> _cache = {};

  static Future<List<Entry>> load(Category c) async {
    final cached = _cache[c];
    if (cached != null) return cached;
    final out = <Entry>[];
    final seen = <String>{};
    for (final f in c.files) {
      final text = await rootBundle.loadString('assets/data/$f');
      for (final line in text.split('\n')) {
        final p = line.trimRight().split('\t');
        if (p.length < 3 || p[0].trim().isEmpty) continue;
        final heb = p[0].trim();
        if (!seen.add(heb)) continue;
        out.add(Entry('${c.name}:$heb', heb, p[1].trim(), p[2].trim(),
            p.length > 3 && p[3].trim().isNotEmpty ? p[3].trim() : null));
      }
    }
    return _cache[c] = out;
  }
}
