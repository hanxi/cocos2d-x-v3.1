package com.example.adsjarsample;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import com.wandoujia.ads.sdk.Ads;
import com.wandoujia.ads.sdk.loader.Fetcher;

public class MainActivity extends FragmentActivity {

  private static final String TAG = "Ads-Jar-Sample";

  private static final String ADS_APP_ID = "100001049";
  private static final String ADS_SECRET_KEY = "1c2523e41b2ad4cbc1caa32ae4fffe13";

  private static final String TAG_LIST = "ec6e157d7bf91e974cc039234bcee955";
  private static final String TAG_INTERSTITIAL_FULLSCREEN = "ec6e157d7bf91e974cc039234bcee955";
  private static final String TAG_INTERSTITIAL_WIDGET = "ec6e157d7bf91e974cc039234bcee955";
  // private static final String TAG_INTERSTITIAL_FULLSCREEN = "Ads_show_in_fullScreen";
  // private static final String TAG_INTERSTITIAL_WIDGET = "Ads_show_as_widget";
    
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    findViewById(R.id.show_apps_button).setOnClickListener(new View.OnClickListener() {

      @Override
      public void onClick(View v) {
        Ads.showAppWall(MainActivity.this, TAG_LIST);

      }

    });

    findViewById(R.id.show_app_widget_button).setOnClickListener(new View.OnClickListener() {

      @Override
      public void onClick(View v) {
        Ads.showAppWidget(MainActivity.this, null, TAG_INTERSTITIAL_FULLSCREEN, Ads.ShowMode.FULL_SCREEN);

      }

    });

    findViewById(R.id.show_app_widget_button_exception).setOnClickListener(new View.OnClickListener() {

      @Override
      public void onClick(View v) {
        Ads.showAppWidget(MainActivity.this, null, "A-TAG", Ads.ShowMode.FULL_SCREEN);

      }

    });

    try {
      Ads.init(this, ADS_APP_ID, ADS_SECRET_KEY);
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }

    Ads.preLoad(this, Fetcher.AdFormat.appwall, TAG_LIST);

    final ViewGroup adsWidgetContainer = (ViewGroup) findViewById(R.id.ads_widget_container);

    final Fetcher.AdFormat adFormat = Fetcher.AdFormat.interstitial;
    if (Ads.isLoaded(adFormat, TAG_LIST)) {
      showAppWidget(adsWidgetContainer);
    } else {
      adsWidgetContainer.setVisibility(View.GONE);
      Log.d(TAG, "Preload data for interstitial Ads.");
      Ads.preLoad(this, adFormat, TAG_INTERSTITIAL_WIDGET);
      new Thread() {
        @Override
        public void run() {
          try {
            while (!Ads.isLoaded(adFormat, TAG_INTERSTITIAL_WIDGET)) {
              Log.d(TAG, "Wait loading for a while...");
              Thread.sleep(2000);
            }
            Log.d(TAG, "Ads data had been loaded.");
            new Handler(Looper.getMainLooper()).post(new Runnable() {
              @Override
              public void run() {
                adsWidgetContainer.setVisibility(View.VISIBLE);
                showAppWidget(adsWidgetContainer);
              }
            });
          } catch (InterruptedException e) {
            e.printStackTrace();
          }
        }
      }.start();
    }

    showBannerAd();
  }

  void showAppWidget(final ViewGroup container) {
    container.addView(Ads.showAppWidget(this, null, TAG_INTERSTITIAL_WIDGET, Ads.ShowMode.WIDGET, new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        container.setVisibility(View.GONE);
      }
    }));
  }

  void showBannerAd() {
    Ads.showBannerAd(this, (ViewGroup) findViewById(R.id.banner_ad_container), "ec6e157d7bf91e974cc039234bcee955");
  }

}
