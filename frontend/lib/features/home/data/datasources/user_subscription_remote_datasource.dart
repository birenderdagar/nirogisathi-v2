import 'package:nirogisathi/core/constants/api_constants.dart';
import 'package:nirogisathi/core/network/api_client.dart';
import '../../domain/entities/user_subscription.dart';

class UserSubscriptionRemoteDataSource {
  final ApiClient _apiClient;

  UserSubscriptionRemoteDataSource(this._apiClient);

  Future<UserSubscriptionStatus> fetchMySubscription() async {
    final uid = _apiClient.localStorage.getUid();
    if (uid == null || uid.isEmpty) {
      return const UserSubscriptionStatus(hasActiveSubscription: false);
    }

    final response = await _apiClient.post(
      ApiConstants.mySubscription,
      data: {'user_id': int.tryParse(uid) ?? uid},
    );

    return _mapStatus(response.data);
  }

  Future<UserSubscriptionStatus> activateSubscription({
    required String planSlug,
    int? subscriptionId,
    String paymentMethod = 'upi',
  }) async {
    final uid = _apiClient.localStorage.getUid();
    if (uid == null || uid.isEmpty) {
      throw Exception('Please login again to activate subscription');
    }

    final response = await _apiClient.post(
      ApiConstants.activateSubscription,
      data: {
        'user_id': int.tryParse(uid) ?? uid,
        'plan_slug': planSlug,
        'subscription_id': ?subscriptionId,
        'payment_method': paymentMethod,
      },
    );

    final body = response.data;
    if (body is Map && body['success'] == false) {
      throw Exception(body['message']?.toString() ?? 'Activation failed');
    }

    return _mapStatus(body);
  }

  UserSubscriptionStatus _mapStatus(dynamic body) {
    final map = body is Map<String, dynamic>
        ? body
        : (body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{});
    final data = map['data'] is Map
        ? Map<String, dynamic>.from(map['data'] as Map)
        : <String, dynamic>{};

    final subRaw = data['subscription'];
    UserSubscriptionInfo? sub;
    if (subRaw is Map) {
      final s = Map<String, dynamic>.from(subRaw);
      final features = <Map<String, dynamic>>[];
      final featuresRaw = s['features'];
      if (featuresRaw is List) {
        for (final f in featuresRaw) {
          if (f is Map) features.add(Map<String, dynamic>.from(f));
        }
      }
      sub = UserSubscriptionInfo(
        id: (s['id'] as num?)?.toInt() ?? 0,
        planName: s['plan_name']?.toString() ?? '',
        planSlug: s['plan_slug']?.toString() ?? '',
        price: (s['price'] as num?)?.toDouble() ?? 0,
        priceDisplay: s['price_display']?.toString(),
        billingLabel: s['billing_label']?.toString(),
        features: features,
        status: s['status']?.toString() ?? 'active',
        isActive: s['is_active'] == true || s['status']?.toString() == 'active',
        startsAt: s['starts_at']?.toString(),
        endsAt: s['ends_at']?.toString(),
      );
    }

    final haRaw = data['health_assistant'];
    HealthAssistantInfo? ha;
    if (haRaw is Map) {
      final h = Map<String, dynamic>.from(haRaw);
      ha = HealthAssistantInfo(
        name: h['name']?.toString() ?? 'Health Assistant',
        title: h['title']?.toString() ?? 'Your Personal Health Assistant',
        employeeId: h['employee_id']?.toString(),
        mobile: h['mobile']?.toString(),
        email: h['email']?.toString(),
        photoUrl: h['photo_url']?.toString(),
        rating: h['rating']?.toString() ?? '4.8/5',
      );
    }

    return UserSubscriptionStatus(
      hasActiveSubscription: data['has_active_subscription'] == true || sub != null,
      subscription: sub,
      healthAssistant: ha,
    );
  }
}
