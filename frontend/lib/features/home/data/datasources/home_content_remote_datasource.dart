import 'package:nirogisathi/core/constants/api_constants.dart';
import 'package:nirogisathi/core/network/api_client.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/entities/home_banner.dart';

class HomeContentRemoteDataSource {
  final ApiClient _apiClient;

  HomeContentRemoteDataSource(this._apiClient);

  Future<List<CurrentUpdateItem>> fetchCurrentUpdates() async {
    final response = await _apiClient.get(ApiConstants.currentUpdates);
    final list = _extractList(response.data);

    return list.map((raw) {
      final json = Map<String, dynamic>.from(raw);
      return CurrentUpdateItem(
        id: (json['id'] as num?)?.toInt() ?? 0,
        value: json['value']?.toString() ?? '',
        label: (json['label']?.toString() ?? '').replaceAll('\\n', '\n'),
        bgColor: ColorValue.fromHex(json['bg_color'] as String?, fallback: 0xFFEFF6FF).value,
        textColor: ColorValue.fromHex(json['text_color'] as String?, fallback: 0xFF1D4ED8).value,
      );
    }).toList();
  }

  Future<List<SubscriptionPlanItem>> fetchSubscriptions() async {
    final response = await _apiClient.get(ApiConstants.subscriptions);
    final list = _extractList(response.data);
    return list.map((raw) => _mapSubscription(Map<String, dynamic>.from(raw))).toList();
  }

  Future<SubscriptionPlanItem> fetchSubscriptionBySlug(String slug) async {
    final response = await _apiClient.get('${ApiConstants.subscriptions}/$slug');
    final body = response.data;
    final json = body is Map<String, dynamic>
        ? Map<String, dynamic>.from(body['data'] as Map)
        : Map<String, dynamic>.from(body as Map);
    return _mapSubscription(json);
  }

  SubscriptionPlanItem _mapSubscription(Map<String, dynamic> json) {
    final sectionsRaw = json['feature_sections'] ?? json['features'];
    final sections = <SubscriptionFeatureSection>[];

    if (sectionsRaw is List) {
      for (final raw in sectionsRaw) {
        if (raw is! Map) {
          if (raw is String) {
            sections.add(
              SubscriptionFeatureSection(
                title: 'Features',
                items: [SubscriptionFeatureItem(text: raw, isLocked: false)],
              ),
            );
          }
          continue;
        }
        final section = Map<String, dynamic>.from(raw);
        final itemsRaw = section['items'];
        final items = <SubscriptionFeatureItem>[];
        if (itemsRaw is List) {
          for (final item in itemsRaw) {
            if (item is String) {
              items.add(SubscriptionFeatureItem(text: item, isLocked: false));
            } else if (item is Map) {
              final map = Map<String, dynamic>.from(item);
              items.add(
                SubscriptionFeatureItem(
                  text: map['text']?.toString() ?? '',
                  isLocked: map['is_locked'] == true || map['is_locked'] == 1,
                ),
              );
            }
          }
        }
        sections.add(
          SubscriptionFeatureSection(
            title: section['title']?.toString() ?? 'Features',
            items: items,
          ),
        );
      }
    }

    return SubscriptionPlanItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      priceDisplay: json['price_display']?.toString() ?? '',
      billingLabel: json['billing_label']?.toString() ??
          json['description']?.toString() ??
          '',
      payButtonText: json['pay_button_text']?.toString() ?? 'Pay Now',
      icon: json['icon']?.toString() ?? 'awesome',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      accentColor: ColorValue.fromHex(
        json['accent_color'] as String?,
        fallback: 0xFFF97316,
      ).value,
      appRoute: json['app_route']?.toString() ?? '/subscription-pack',
      description: json['description']?.toString(),
      featureSections: sections,
    );
  }

  List<Map> _extractList(dynamic body) {
    if (body is Map<String, dynamic>) {
      return (body['data'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .toList();
    }
    if (body is List) {
      return body.whereType<Map>().toList();
    }
    return const [];
  }
}
