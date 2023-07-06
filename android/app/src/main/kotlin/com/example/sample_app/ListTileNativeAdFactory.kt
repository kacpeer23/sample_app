package com.example.sample_app

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import android.graphics.Color
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin


class ListTileNativeAdFactory(val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
            nativeAd: NativeAd,
            customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
                .inflate(R.layout.list_tile_native_ad, null) as NativeAdView
        val darkMode = customOptions?.get("darkMode") ?: false
        with(nativeAdView) {
            val attributionViewLarge =
                    findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_large)

            val iconView = findViewById<ImageView>(R.id.iv_list_tile_native_ad_icon)
            val icon = nativeAd.icon
            if (icon != null) {
                attributionViewLarge.visibility = View.INVISIBLE
                iconView.setImageDrawable(icon.drawable)
            } else {
                attributionViewLarge.visibility = View.VISIBLE
            }
            this.iconView = iconView

            val headlineView = findViewById<TextView>(R.id.tv_list_tile_native_ad_headline)
            headlineView.text = nativeAd.headline
            headlineView.setTextColor(if(darkMode == true) Color.parseColor("#FFFFFF") else Color.parseColor("#000000"))
            this.headlineView = headlineView
            val advertiserView = findViewById<TextView>(R.id.tv_list_tile_native_ad_advertiser)
            with(advertiserView) {
                text = nativeAd.advertiser
                visibility = if (nativeAd.advertiser.isNullOrEmpty()) View.INVISIBLE else View.VISIBLE
            }
            advertiserView.setTextColor(if(darkMode == true) Color.parseColor("#FFFFFF") else Color.parseColor("#000000"))
            this.advertiserView = advertiserView
            val callToActionView = findViewById<TextView>(R.id.tv_list_tile_native_ad_callToAction)
            with(callToActionView) {
                text = nativeAd.callToAction
                visibility = if (nativeAd.callToAction.isNullOrEmpty()) View.INVISIBLE else View.VISIBLE
            }
            callToActionView.setTextColor(if(darkMode == true) Color.parseColor("#FFFFFF") else Color.parseColor("#000000"))
            this.callToActionView = callToActionView
            val bodyView = findViewById<TextView>(R.id.tv_list_tile_native_ad_body)
            with(bodyView) {
                text = nativeAd.body
                visibility = if (nativeAd.body.isNullOrEmpty()) View.INVISIBLE else View.VISIBLE
            }
            bodyView.setTextColor(if(darkMode == true) Color.parseColor("#FFFFFF") else Color.parseColor("#000000"))
            this.bodyView = bodyView
            val advertisementView = findViewById<TextView>(R.id.tv_list_tile_native_ad_advertisement)
            with(advertiserView) {
                visibility = if (nativeAd.advertiser.isNullOrEmpty()) View.INVISIBLE else View.VISIBLE
            }
            advertisementView.textAlignment = View.TEXT_ALIGNMENT_VIEW_END
            advertisementView.setTextColor(if(darkMode == true) Color.parseColor("#FFFFFF") else Color.parseColor("#000000"))
            setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}