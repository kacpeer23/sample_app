import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'constants.dart';

class AdvertisementTile extends StatefulWidget {
  static RxBool forceRefresh = false.obs;

  AdvertisementTile({Key? key}) : super(key: key);

  @override
  State<AdvertisementTile> createState() => _AdvertisementTileState();
}

class _AdvertisementTileState extends State<AdvertisementTile> with AutomaticKeepAliveClientMixin {
  late NativeAd native;
  bool isDarkMode = false;
  RxBool isAdLoaded = false.obs;
  RxBool isAdVisible = false.obs;
  RxBool adError = false.obs;
  StreamSubscription<dynamic>? _forceRefreshSubscription;

  @override
  void initState() {
    _forceRefreshSubscription?.cancel();
    _forceRefreshSubscription = AdvertisementTile.forceRefresh.listen((forceRefresh) {
      if (forceRefresh) {
        setState(() {
          isAdLoaded.value = false;
          isAdVisible.value = false;
          adError.value = false;
          _prepareNativeAd();
        });
      }
      AdvertisementTile.forceRefresh.value = false;
    });

    _prepareNativeAd();
    super.initState();
  }

  void _prepareNativeAd() {
    native = NativeAd.fromAdManagerRequest(
        // adUnitId: '/6499/example/native',
        adUnitId: Platform.isAndroid ? Constants.adUnitIDAndroid : Constants.adUnitIDiOS,
        factoryId: 'listTile',
        nativeAdOptions: NativeAdOptions(),
        listener: NativeAdListener(onPaidEvent: (ad, double, precisionType, string) {
          print('AD_PRINT PAID $ad double $double, type $precisionType, string $string');
        }, onAdFailedToLoad: (ad, loadAdError) {
          print('AD_PRINT FAILED ${ad.adUnitId} _ ${ad.responseInfo} loadAdError $loadAdError');
          adError.value = true;
          native.dispose();
        }, onAdLoaded: (ad) {
          print('AD_PRINT LOADED ${ad.adUnitId} _ ${ad.responseInfo}');
          isAdLoaded.value = true;
          isAdVisible.value = false;
        }, onAdClicked: (ad) {
          log('AD_PRINT Clicked $ad');
          // log('AD: ${ad.responseInfo}');
        }, onAdClosed: (ad) {
          print('AD_PRINT Closed $ad');
        }, onAdImpression: (ad) {
          isAdVisible.value = true;
          print('AD_PRINT Impression $ad');
          // log('AD: ${ad.responseInfo}');
        }, onAdOpened: (ad) {
          print('AD_PRINT Opened $ad');
        }, onAdWillDismissScreen: (ad) {
          print('AD_PRINT WillDismissScreen $ad');
        }),
        adManagerRequest: AdManagerAdRequest(customTargeting: {
          'site': Platform.isAndroid ? Constants.adSiteAndroid : Constants.adSiteiOS,
          'slot': 'nativestd',
          'native_custom_templates': '12244219'
        }, customTargetingLists: {
          'kwrds': ['poczta_odebrane', 'tst_direct']
        }));
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = context.isDarkMode;
    native.customOptions = {'darkMode': isDarkMode};
    native.load();
    super.build(context);
    return Obx(() {
      return Visibility(
        visible: !adError.value,
        child: Stack(children: [
          Positioned.fill(
            child: Container(
                margin: const EdgeInsets.only(top: 4.3, bottom: 8.3, left: 5.3, right: 5.3),
                decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(16))),
          ),
          Container(
            decoration:
                BoxDecoration(color: context.theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(
              left: 5.3,
              right: 5.3,
              top: 4.3,
              bottom: 8.3,
            ),
            width: Get.width,
            height: 70,
            child: Obx(() {
              return Stack(children: [
                isAdLoaded.value ? AdWidget(ad: native) : Container(),
                Visibility(
                  visible: !isAdVisible.value,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ]);
            }),
          ),
        ]),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    native.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isAdLoaded.value = false;
      isAdVisible.value = true;
    });
    _forceRefreshSubscription?.cancel();
    super.dispose();
  }
}
