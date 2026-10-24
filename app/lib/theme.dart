import 'package:flutter/material.dart';

class AncientPalette {
  static const obsidian = Color(0xFF130E0A);
  static const wood = Color(0xFF22170F);
  static const woodDark = Color(0xFF18100A);
  static const woodBorder = Color(0xFF382414);
  static const parchmentLight = Color(0xFFF4E7CE);
  static const parchmentMid = Color(0xFFE8D4B0);
  static const parchmentDark = Color(0xFFD3B88C);
  static const inkDeep = Color(0xFF1E130C);
  static const inkBrown = Color(0xFF3E2817);
  static const inkFaded = Color(0xFF6E5239);
  static const goldBright = Color(0xFFE0B252);
  static const goldLeaf = Color(0xFFC59337);
  static const goldBronze = Color(0xFF8C6422);
  static const crimsonWax = Color(0xFF8B261D);
  static const crimsonBright = Color(0xFFA93226);
  static const sageOlive = Color(0xFF3B5E36);

  static BoxDecoration parchmentBox({double radius = 8.0, bool elevated = true}) {
    return BoxDecoration(
      gradient: const RadialGradient(
        center: Alignment(0.0, -0.1),
        radius: 1.1,
        colors: [parchmentLight, parchmentMid, parchmentDark],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: goldBronze, width: 2),
      boxShadow: elevated
          ? const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration woodBox({double radius = 8.0}) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [wood, woodDark],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: goldBronze, width: 1.5),
      boxShadow: const [
        BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4)),
      ],
    );
  }
}
