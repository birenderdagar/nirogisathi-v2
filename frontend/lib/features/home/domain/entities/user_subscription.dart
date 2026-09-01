class HealthAssistantInfo {
  final String name;
  final String title;
  final String? employeeId;
  final String? mobile;
  final String? email;
  final String? photoUrl;
  final String rating;

  const HealthAssistantInfo({
    required this.name,
    required this.title,
    this.employeeId,
    this.mobile,
    this.email,
    this.photoUrl,
    this.rating = '4.8/5',
  });
}

class UserSubscriptionInfo {
  final int id;
  final String planName;
  final String planSlug;
  final double price;
  final String? priceDisplay;
  final String? billingLabel;
  final List<Map<String, dynamic>> features;
  final String status;
  final bool isActive;
  final String? startsAt;
  final String? endsAt;

  const UserSubscriptionInfo({
    required this.id,
    required this.planName,
    required this.planSlug,
    required this.price,
    this.priceDisplay,
    this.billingLabel,
    this.features = const [],
    required this.status,
    required this.isActive,
    this.startsAt,
    this.endsAt,
  });
}

class UserSubscriptionStatus {
  final bool hasActiveSubscription;
  final UserSubscriptionInfo? subscription;
  final HealthAssistantInfo? healthAssistant;

  const UserSubscriptionStatus({
    required this.hasActiveSubscription,
    this.subscription,
    this.healthAssistant,
  });
}

/// Passed to payment gateway when paying for a subscription plan.
class SubscriptionPaymentExtra {
  final double amount;
  final int? subscriptionId;
  final String planSlug;
  final String planName;

  const SubscriptionPaymentExtra({
    required this.amount,
    required this.planSlug,
    required this.planName,
    this.subscriptionId,
  });
}
