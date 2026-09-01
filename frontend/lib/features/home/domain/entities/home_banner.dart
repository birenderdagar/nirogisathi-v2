class HomeBanner {
  final int id;
  final String title;
  final String buttonText;
  final String imageUrl;
  final ColorValue bgColor;
  final String actionType;
  final String? actionValue;
  final bool openInNewTab;
  final int sortOrder;

  const HomeBanner({
    required this.id,
    required this.title,
    required this.buttonText,
    required this.imageUrl,
    required this.bgColor,
    this.actionType = 'none',
    this.actionValue,
    this.openInNewTab = false,
    this.sortOrder = 0,
  });
}

/// Lightweight color holder so the model stays free of Flutter imports if needed.
/// Parsed to Color in the UI layer.
class ColorValue {
  final int value;
  const ColorValue(this.value);

  factory ColorValue.fromHex(String? hex, {int fallback = 0xFFE3F2FD}) {
    if (hex == null || hex.isEmpty) return ColorValue(fallback);
    var cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    final parsed = int.tryParse(cleaned, radix: 16);
    return ColorValue(parsed ?? fallback);
  }
}
