import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Progress (set of learned entry ids) + text-to-speech.
class Store extends ChangeNotifier {
  Store._();
  static final Store i = Store._();

  late SharedPreferences _prefs;
  final Set<String> _known = {};
  final FlutterTts _tts = FlutterTts();
  bool showTranslit = true;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _known.addAll(_prefs.getStringList('known') ?? const []);
    showTranslit = _prefs.getBool('translit') ?? true;
    try {
      await _tts.setLanguage('he-IL');
      await _tts.setSpeechRate(0.4);
    } catch (_) {}
  }

  bool isKnown(String id) => _known.contains(id);
  int knownCount(String prefix) => _known.where((k) => k.startsWith(prefix)).length;

  void setKnown(String id, bool v) {
    v ? _known.add(id) : _known.remove(id);
    _prefs.setStringList('known', _known.toList());
    notifyListeners();
  }

  int stars(String glyph) => _prefs.getInt('stars:$glyph') ?? 0;

  void setStars(String glyph, int s) {
    if (s > stars(glyph)) _prefs.setInt('stars:$glyph', s);
    notifyListeners();
  }

  void setTranslit(bool v) {
    showTranslit = v;
    _prefs.setBool('translit', v);
    notifyListeners();
  }

  Future<void> speak(String hebrew) async {
    // TTS reads unpointed text more reliably; strip nikud marks.
    final plain = hebrew.replaceAll(RegExp('[\u0591-\u05C7]'), '');
    try {
      await _tts.stop();
      await _tts.speak(plain);
    } catch (_) {}
  }
}
