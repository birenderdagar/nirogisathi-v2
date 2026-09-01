import 'package:nirogisathi/core/constants/api_constants.dart';
import 'package:nirogisathi/core/network/api_client.dart';
import '../../domain/entities/home_banner.dart';

class BannerRemoteDataSource {
  final ApiClient _apiClient;

  BannerRemoteDataSource(this._apiClient);

  Future<List<HomeBanner>> fetchActiveBanners() async {
    final response = await _apiClient.get(ApiConstants.banners);
    final body = response.data;

    final list = body is Map<String, dynamic>
        ? (body['data'] as List<dynamic>? ?? const [])
        : (body as List<dynamic>? ?? const []);

    return list
        .whereType<Map>()
        .map((raw) => _mapBanner(Map<String, dynamic>.from(raw)))
        .where((b) => b.imageUrl.isNotEmpty)
        .toList();
  }

  HomeBanner _mapBanner(Map<String, dynamic> json) {
    return HomeBanner(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?)?.replaceAll('\\n', '\n') ?? '',
      buttonText: json['button_text'] as String? ?? 'Learn More',
      imageUrl: _resolveImageUrl(
        json['image_url'] as String?,
        json['image_path'] as String?,
      ),
      bgColor: ColorValue.fromHex(json['bg_color'] as String?),
      actionType: json['action_type'] as String? ?? 'none',
      actionValue: json['action_value'] as String?,
      openInNewTab: json['open_in_new_tab'] == true || json['open_in_new_tab'] == 1,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  String _resolveImageUrl(String? imageUrl, String? imagePath) {
    // Prefer uploaded storage path (reliable). Admin "image_url" is often
    // misused for CTA links, so only use it when it looks like an image.
    if (imagePath != null && imagePath.trim().isNotEmpty) {
      final path = imagePath.trim();
      if (path.startsWith('http://') || path.startsWith('https://')) {
        return _rewriteLocalhost(path);
      }
      return _rewriteLocalhost(
        '${ApiConstants.storageUrl}${path.replaceFirst(RegExp(r'^/'), '')}',
      );
    }

    if (imageUrl != null && imageUrl.trim().isNotEmpty && _looksLikeImageUrl(imageUrl)) {
      return _rewriteLocalhost(imageUrl.trim());
    }

    return '';
  }

  bool _looksLikeImageUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('/storage/') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.gif');
  }

  String _rewriteLocalhost(String url) {
    final apiHost = Uri.parse(ApiConstants.baseUrl);
    final port = apiHost.hasPort ? ':${apiHost.port}' : '';
    final origin = '${apiHost.scheme}://${apiHost.host}$port';
    return url
        .replaceFirst(RegExp(r'https?://127\.0\.0\.1(:\d+)?'), origin)
        .replaceFirst(RegExp(r'https?://localhost(:\d+)?'), origin);
  }
}
