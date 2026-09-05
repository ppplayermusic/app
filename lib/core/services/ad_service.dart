import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to manage Google Mobile Ads.
class AdService {
  AdService() {
    // Defer Ad initialization to reduce startup pressure on Android.
    _initializationFuture = Future.delayed(const Duration(seconds: 15), () async {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        return MobileAds.instance.initialize();
      }
      return InitializationStatus({});
    });
  }

  late final Future<InitializationStatus> _initializationFuture;
  Future<InitializationStatus> get initialization => _initializationFuture;

  /// Get the banner ad unit ID based on the platform.
  /// These are test IDs from Google.
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }

  /// Create a new banner ad.
  BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  /// Returns a list of mock promotions for UI testing.
  List<Map<String, String>> getPromoData() {
    return [
      {
        'title': 'Premium Headphones',
        'subtitle': 'Experience pure sound with NoiseCancelling 3.0',
        'cta': 'Shop now',
        'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200',
      },
      {
        'title': 'Artist Spotlight: Wavey',
        'subtitle': 'Check out the new album "Ocean Drift"',
        'cta': 'Listen',
        'image': 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200',
      },
       {
        'title': 'Coffee & Lo-fi',
        'subtitle': 'Relax with our curated workstation playlist.',
        'cta': 'Explore',
        'image': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200',
      },
    ];
  }
}

final adServiceProvider = Provider<AdService>((ref) => AdService());
