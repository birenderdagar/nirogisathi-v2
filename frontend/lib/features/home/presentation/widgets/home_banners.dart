import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nirogisathi/app/di/injection.dart';
import '../../data/datasources/banner_remote_datasource.dart';
import '../../domain/entities/home_banner.dart';

class HomeBanners extends StatefulWidget {
  const HomeBanners({super.key});

  @override
  State<HomeBanners> createState() => _HomeBannersState();
}

class _HomeBannersState extends State<HomeBanners> {
  late Future<List<HomeBanner>> _bannersFuture;

  static const List<HomeBanner> _fallbackBanners = [
    HomeBanner(
      id: -1,
      title: 'PATIENTS ARE OUR\nPRIORITY',
      buttonText: 'Book Now',
      imageUrl:
          'https://img.freepik.com/free-photo/doctors-day-cute-young-female-doctor-white-lab-coat-with-stethoscope-smiling-confidently_144627-46338.jpg',
      bgColor: ColorValue(0xFFE3F2FD),
    ),
    HomeBanner(
      id: -2,
      title: 'BEST CONSULTATION\nWITH SPECIALISTS',
      buttonText: 'Find Doctor',
      imageUrl:
          'https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-holding-clipboard_23-2148168407.jpg',
      bgColor: ColorValue(0xFFE3F2FD),
    ),
    HomeBanner(
      id: -3,
      title: 'LATEST TECHNOLOGY\nIN DIAGNOSTICS',
      buttonText: 'Book Test',
      imageUrl:
          'https://img.freepik.com/free-photo/scientists-working-together-lab_23-2148812480.jpg',
      bgColor: ColorValue(0xFFE3F2FD),
    ),
    HomeBanner(
      id: -4,
      title: 'CARING FOR YOUR\nLITTLE ONES',
      buttonText: 'Pediatrician',
      imageUrl:
          'https://img.freepik.com/free-photo/doctor-examining-little-girl-hospital_23-2148352219.jpg',
      bgColor: ColorValue(0xFFE3F2FD),
    ),
    HomeBanner(
      id: -5,
      title: '24/7 SUPPORT\nFOR ELDERLY CARE',
      buttonText: 'Learn More',
      imageUrl:
          'https://img.freepik.com/free-photo/nurse-helping-senior-woman-walk_23-2148232777.jpg',
      bgColor: ColorValue(0xFFE3F2FD),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannersFuture = _loadBanners();
  }

  Future<List<HomeBanner>> _loadBanners() async {
    try {
      final banners = await getIt<BannerRemoteDataSource>().fetchActiveBanners();
      if (banners.isEmpty) {
        debugPrint('HomeBanners: API returned 0 banners, using fallback');
        return _fallbackBanners;
      }
      debugPrint('HomeBanners: loaded ${banners.length} banner(s) from API');
      return banners;
    } catch (e, st) {
      debugPrint('HomeBanners: API failed → $e');
      debugPrint('$st');
      return _fallbackBanners;
    }
  }

  Future<void> _onBannerTap(HomeBanner banner) async {
    final value = banner.actionValue?.trim() ?? '';
    var actionType = (banner.actionType).trim().toLowerCase();

    if (actionType.isEmpty || actionType == 'none') {
      _showMessage('No action set for this banner');
      return;
    }

    if (value.isEmpty) {
      _showMessage('Banner action value is missing');
      return;
    }

    // Normalize aliases / common admin mistakes
    if (actionType == 'call' || actionType == 'dial') actionType = 'phone';
    if (actionType == 'url' || actionType == 'link' || actionType == 'web') {
      actionType = 'external_url';
    }
    if (actionType == 'route' || actionType == 'screen' || actionType == 'app') {
      actionType = 'app_route';
    }
    if (actionType == 'external_url' && value.startsWith('/')) {
      actionType = 'app_route';
    }
    if (actionType == 'app_route' &&
        (value.startsWith('http://') || value.startsWith('https://'))) {
      actionType = 'external_url';
    }

    try {
      switch (actionType) {
        case 'app_route':
          final route = value.startsWith('/') ? value : '/$value';
          if (!mounted) return;
          context.push(route);
          break;

        case 'external_url':
          final normalized = value.startsWith('http://') || value.startsWith('https://')
              ? value
              : 'https://$value';
          final uri = Uri.parse(normalized);
          final ok = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (!ok) _showMessage('Could not open link');
          break;

        case 'phone':
          await _launchPhone(value);
          break;

        case 'whatsapp':
          await _launchWhatsApp(value);
          break;

        default:
          _showMessage('Unknown banner action: $actionType');
      }
    } catch (e) {
      debugPrint('HomeBanners tap failed: $e');
      _showMessage('Could not open action');
    }
  }

  Future<void> _launchPhone(String raw) async {
    var phone = raw.trim();
    // Keep leading + for country code; strip other junk.
    phone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (phone.startsWith('00')) {
      phone = '+${phone.substring(2)}';
    }
    if (phone.isEmpty) {
      _showMessage('Invalid phone number');
      return;
    }

    // Prefer dial pad (more reliable than tel: on some OEMs).
    final dialUri = Uri(scheme: 'tel', path: phone);
    final launched = await launchUrl(
      dialUri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      _showMessage('Could not open phone dialer');
    }
  }

  Future<void> _launchWhatsApp(String raw) async {
    final digits = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      _showMessage('Invalid WhatsApp number');
      return;
    }

    final native = Uri.parse('whatsapp://send?phone=$digits');
    final web = Uri.parse('https://wa.me/$digits');

    try {
      if (await canLaunchUrl(native)) {
        await launchUrl(native, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    final ok = await launchUrl(web, mode: LaunchMode.externalApplication);
    if (!ok) _showMessage('Could not open WhatsApp');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: FutureBuilder<List<HomeBanner>>(
        future: _bannersFuture,
        builder: (context, snapshot) {
          final banners = snapshot.data ?? _fallbackBanners;

          return PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) => _buildBanner(banners[index]),
          );
        },
      ),
    );
  }

  Widget _buildBanner(HomeBanner banner) {
    final bgColor = Color(banner.bgColor.value);
    final hasAction =
        banner.actionType != 'none' && (banner.actionValue?.trim().isNotEmpty ?? false);

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: hasAction ? () => _onBannerTap(banner) : null,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              width: 180,
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.blue.shade100),
              ),
            ),
            // Don't steal taps from the CTA button.
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      bgColor,
                      bgColor.withValues(alpha: 0.8),
                      bgColor.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.5, 0.9],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF00456A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: hasAction ? () => _onBannerTap(banner) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00456A),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF00456A),
                      disabledForegroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text(
                      banner.buttonText,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
