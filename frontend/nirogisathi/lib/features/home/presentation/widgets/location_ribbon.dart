import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../location/presentation/provider/location_provider.dart';

class LocationRibbon extends StatefulWidget {
  const LocationRibbon({super.key});

  @override
  State<LocationRibbon> createState() => _LocationRibbonState();
}

class _LocationRibbonState extends State<LocationRibbon> {
  @override
  void initState() {
    super.initState();
    // ✅ Automatically fetch location when ribbon appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LocationProvider>();
      if (provider.location == null) {
        provider.fetchCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        final address = provider.location?.address ?? "Fetching location...";
        
        return InkWell(
          onTap: () => context.push('/add-location'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              // ✅ Use the primary theme color for visibility
              color: Color(0xFF00456A),
              border: Border(
                top: BorderSide(color: Colors.white10),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    provider.errorMessage ?? address,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                if (provider.isLoading)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(Icons.chevron_right, size: 14, color: Colors.white70),
              ],
            ),
          ),
        );
      },
    );
  }
}
