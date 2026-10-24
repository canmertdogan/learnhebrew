# LearnHebrew

LearnHebrew is a polished, scriptorium-inspired Hebrew learning app built around Torah passages, vocabulary, verbs, sentences, handwriting practice, and a searchable dictionary. It runs as a web app and is packaged for macOS and Android.

## Highlights

- **Dashboard journey** with XP, streak, accuracy, due reviews, daily quests, and Leitner memory boxes.
- **Torah reader** with clickable words and contextual meanings.
- **Vocabulary, verbs, and sentences** with flashcards and quizzes.
- **Handwriting practice** with tracing and scoring.
- **Hebrew–Turkish dictionary** with thousands of entries.
- **Turkish and English** interface.
- **Sound, animations, transliteration, and daily goals**.
- Responsive layout for mobile, tablet, and desktop.

## Project Structure

```text
web_app/        Web application (HTML/CSS/JavaScript)
android_app/    Android wrapper project
macos_native/   macOS native wrapper sources
LearnHebrew.app macOS application bundle
data_src/       Source data and translation files
```

## Running the Web App

Open `web_app/index.html` in a modern browser, or serve the folder locally:

```bash
cd web_app
python3 -m http.server 8080
```

Then visit `http://127.0.0.1:8080`.

## Releases

Prebuilt downloads are available on the GitHub Releases page:

- **macOS**: `LearnHebrew-macOS.zip`
- **Windows**: `LearnHebrew-Windows.zip` (portable web build; open `index.html` in a browser)
- **Android**: `LearnHebrew-Android.apk`

## Building

### Web

No build step is required. Edit files in `web_app/` and refresh.

### Android

```bash
cd android_app
export JAVA_HOME="/path/to/jdk17"
export ANDROID_HOME="/path/to/android/sdk"
gradle assembleDebug
```

The APK is generated at:

```text
app/build/outputs/apk/debug/app-debug.apk
```

### macOS

The macOS bundle is included as `LearnHebrew.app`. Rebuild native wrappers from `macos_native/` if needed.

## Data

- `web_app/data.js` — base words, verbs, and sentences
- `web_app/torah.js` — Torah passages and word glosses
- `web_app/dict_extra.js` — extended dictionary entries

## License

This project is provided for educational use. Fonts and derived dictionary data may have their own licenses.