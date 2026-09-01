class CurrentUpdateItem {
  final int id;
  final String value;
  final String label;
  final int bgColor;
  final int textColor;

  const CurrentUpdateItem({
    required this.id,
    required this.value,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });
}

class SubscriptionFeatureItem {
  final String text;
  final bool isLocked;

  const SubscriptionFeatureItem({
    required this.text,
    required this.isLocked,
  });
}

class SubscriptionFeatureSection {
  final String title;
  final List<SubscriptionFeatureItem> items;

  const SubscriptionFeatureSection({
    required this.title,
    required this.items,
  });
}

class SubscriptionPlanItem {
  final int id;
  final String name;
  final String slug;
  final String priceDisplay;
  final String billingLabel;
  final String payButtonText;
  final String icon;
  final double price;
  final int accentColor;
  final String appRoute;
  final String? description;
  final List<SubscriptionFeatureSection> featureSections;

  const SubscriptionPlanItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.priceDisplay,
    required this.billingLabel,
    required this.payButtonText,
    required this.icon,
    required this.price,
    required this.accentColor,
    required this.appRoute,
    this.description,
    this.featureSections = const [],
  });
}
