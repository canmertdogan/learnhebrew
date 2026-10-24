#!/usr/bin/env python3
"""
Ancient Hebrew Scriptorium — data pipeline.

data_src/*.tsv          KAYNAK: hebrew \t translit \t english [\t present(verbs)]
data_src/tr/<name>.tr   her TSV satırı için birebir hizalı Türkçe çeviri satırı

Çıktı: web_app/data.js (+ android/macos paket kopyaları)
Kullanım: python3 data_src/build_data.py [--check]
"""
import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SRC = ROOT / 'data_src'
DATA_OUT = ROOT / 'web_app' / 'data.js'
COPY_OUTS = [
    ROOT / 'android_app' / 'app' / 'src' / 'main' / 'assets' / 'data.js',
    ROOT / 'LearnHebrew.app' / 'Contents' / 'Resources' / 'data.js',
]

CATS = [
    ('words', ['words_1.tsv', 'words_2.tsv']),
    ('verbs', ['verbs_1.tsv', 'verbs_2.tsv']),
    ('sentences', ['sentences.tsv']),
]

MISSING = []

data = {}
for cat, files in CATS:
    entries, seen = [], set()
    for f in files:
        rows = (SRC / f).read_text('utf-8').splitlines()
        tr_path = SRC / 'tr' / (f[:-4] + '.tr')
        trs = tr_path.read_text('utf-8').splitlines() if tr_path.exists() else []
        if trs and len(trs) != len(rows):
            print(f'!! {tr_path.name}: {len(trs)} satır vs {f}: {len(rows)} satır — satır hizalama bozuk, yine de index ile eşlenir', file=sys.stderr)
        for i, line in enumerate(rows):
            p = line.split('\t')
            if not p or not p[0].strip():
                continue
            heb = p[0].strip()
            if heb in seen:
                continue
            seen.add(heb)
            entry = {'h': heb, 't': p[1].strip(), 'e': p[2].strip()}
            if cat == 'verbs' and len(p) > 3 and p[3].strip():
                entry['x'] = p[3].strip()
            tr = trs[i].strip() if i < len(trs) else ''
            if tr and tr not in ('-', 'TODO'):
                entry['tr'] = tr
            else:
                MISSING.append(f'{tr_path.name if tr_path.exists() else "(yok)"} #{i + 1}: {heb} — {entry["e"]}')
            entries.append(entry)
    data[cat] = entries

# Aynı kategoride bire bir aynı Türkçe gloss'a sahip maddeler: quiz seçeneklerinde
# iki aynı yazılı seçenek doğabilir → kullanıcıya bilgilendirmek için uyar.
for cat, entries in data.items():
    seen_tr = {}
    for ent in entries:
        tr = ent.get('tr', '')
        if tr:
            seen_tr[tr] = seen_tr.get(tr, 0) + 1
    dups = {k: v for k, v in seen_tr.items() if v > 1}
    if dups:
        top = sorted(dups.items(), key=lambda kv: -kv[1])[:10]
        print(f"!! {cat}: aynı Türkçe gloss'u paylaşan {len(dups)} etiket (ilk 10): {top}", file=sys.stderr)

total = sum(len(v) for v in data.values())
print('built:', {k: len(v) for k, v in data.items()}, '| entries with tr:', total - len(MISSING), '| missing tr:', len(MISSING))

payload = 'window.HEBREW_DATA = ' + json.dumps(data, ensure_ascii=False, separators=(',', ': ')) + ';'

if '--check' in sys.argv:
    if MISSING:
        print('ilk 40 eksik:')
        for m in MISSING[:40]:
            print('   ', m)
        sys.exit(1 if MISSING else 0)
    sys.exit(0)

# Cursive font satırı olduğu gibi korunur (data.js 1. satır)
out = ''
if DATA_OUT.exists():
    first = DATA_OUT.read_text('utf-8').splitlines()[0]
    if first.startswith('window.CURSIVE_FONT_B64'):
        out = first + '\n'
out += payload + '\n'
DATA_OUT.write_text(out, 'utf-8')
for dest in COPY_OUTS:
    try:
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(out, 'utf-8')
    except Exception as ex:
        print(f'!! kopyalanamadı {dest}: {ex}', file=sys.stderr)
print('written:', DATA_OUT, '+', len(COPY_OUTS), 'kopya')

if MISSING:
    print('ilk 40 eksik (İngilizce fallback devrede):', file=sys.stderr)
    for m in MISSING[:40]:
        print('   ', m, file=sys.stderr)
