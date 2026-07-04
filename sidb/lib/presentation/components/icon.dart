import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// A simple SVG icon component for neobrutalism styling.
class Icon extends StatelessComponent {
  final String svgPath;
  final String? classes;
  final double? width;
  final double? height;
  final String? strokeWidth;
  final bool filled;
  final Color? fillColor;
  final Color? strokeColor;

  const Icon(
    this.svgPath, {
    this.fillColor = const Color('var(--theme-text)'),
    this.strokeColor = const Color('var(--theme-text)'),
    this.classes,
    this.width,
    this.height,
    this.strokeWidth = '2',
    this.filled = false,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final w = width ?? 24;
    final h = height ?? 24;

    return svg(
      classes: classes ?? 'w-6 h-6',
      attributes: {
        'width': w.toString(),
        'height': h.toString(),
        'viewBox': '0 0 24 24',
      },
      [
        path(
          d: svgPath,
          fill: filled ? fillColor : Colors.transparent,
          stroke: strokeColor,
          strokeWidth: strokeWidth,
          attributes: {
            if (!filled) 'stroke-linecap': 'round',
            if (!filled) 'stroke-linejoin': 'round',
          },
          [],
        ),
      ],
    );
  }
}

/// Common SVG icon paths
class IconPaths {
  static const String search = 'M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z';
  static const String package =
      'M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10';
  static const String users =
      'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z';
  static const String menu = 'M4 6h16M4 10h16M4 14h16M4 18h16';
  static const String thumbUp =
      'M14 10h4.764a2 2 0 011.789 2.894l-3.5 7A2 2 0 0115.263 21h-4.017c-.163 0-.326-.02-.485-.06L7 20m7-10V5a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L7 11v9m7-10h-2M7 20H5a2 2 0 01-2-2v-6a2 2 0 012-2h2.5';
  static const String thumbDown =
      'M10 14H5.236a2 2 0 01-1.789-2.894l3.5-7A2 2 0 018.737 3h4.017c.163 0 .326.02.485.06L17 4m-7 10v5a2 2 0 002 2h.095c.5 0 .905-.405.905-.905 0-.714.211-1.412.608-2.006L17 13V4m-7 10h2m5-10h2a2 2 0 012 2v6a2 2 0 01-2 2h-2.5';
  static const String bookmark = 'M6 4h12a1 1 0 011 1v16l-7-4-7 4V5a1 1 0 011-1z';
  static const String download = 'M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4';
}
