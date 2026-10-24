import os
import subprocess
import shutil

src = "/Users/n0rthstar/Desktop/hebrew/app_icon.png"
if not os.path.exists(src):
    print("Source image not found yet:", src)
    exit(1)

# 1. macOS .iconset and .icns
iconset_dir = "/tmp/AppIcon.iconset"
if os.path.exists(iconset_dir):
    shutil.rmtree(iconset_dir)
os.makedirs(iconset_dir, exist_ok=True)

sizes = [
    (16, "icon_16x16.png"),
    (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"),
    (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"),
    (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"),
    (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"),
    (1024, "icon_512x512@2x.png"),
]

for sz, fname in sizes:
    out_path = os.path.join(iconset_dir, fname)
    subprocess.run(["sips", "-z", str(sz), str(sz), src, "--out", out_path], check=True, capture_output=True)

# Generate AppIcon.icns
icns_path = "/Users/n0rthstar/Desktop/hebrew/LearnHebrew.app/Contents/Resources/AppIcon.icns"
subprocess.run(["iconutil", "-c", "icns", iconset_dir, "-o", icns_path], check=True)
print("Generated macOS icns:", icns_path)

# Update Info.plist to specify CFBundleIconFile
plist_path = "/Users/n0rthstar/Desktop/hebrew/LearnHebrew.app/Contents/Info.plist"
with open(plist_path, "r", encoding="utf-8") as f:
    plist = f.read()
if "CFBundleIconFile" not in plist:
    plist = plist.replace("</dict>", "    <key>CFBundleIconFile</key>\n    <string>AppIcon</string>\n</dict>")
    with open(plist_path, "w", encoding="utf-8") as f:
        f.write(plist)
    print("Updated Info.plist with CFBundleIconFile")

# 2. Android mipmaps
android_res = "/Users/n0rthstar/Desktop/hebrew/android_app/app/src/main/res"
android_sizes = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

for folder, sz in android_sizes.items():
    folder_path = os.path.join(android_res, folder)
    os.makedirs(folder_path, exist_ok=True)
    out_icon = os.path.join(folder_path, "ic_launcher.png")
    out_round = os.path.join(folder_path, "ic_launcher_round.png")
    subprocess.run(["sips", "-z", str(sz), str(sz), src, "--out", out_icon], check=True, capture_output=True)
    shutil.copyfile(out_icon, out_round)

print("Generated Android mipmaps in:", android_res)

# 3. Web favicon / logo
web_icon = "/Users/n0rthstar/Desktop/hebrew/web_app/app_icon.png"
shutil.copyfile(src, web_icon)
shutil.copyfile(src, "/Users/n0rthstar/Desktop/hebrew/LearnHebrew.app/Contents/Resources/app_icon.png")
shutil.copyfile(src, "/Users/n0rthstar/Desktop/hebrew/android_app/app/src/main/assets/app_icon.png")
print("All app icons deployed successfully!")

