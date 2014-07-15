package org.cocos2dx.lua;

import android.app.Dialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.ImageButton;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;
import android.text.Html;
import android.widget.TextView;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import com.wandoujia.ads.sdk.Ads;
import com.wandoujia.ads.sdk.loader.Fetcher;
import com.hanxi.runtodie.R;

public class AppActivity extends Cocos2dxActivity {
    private static AppActivity s_instance;

    private static final String ADS_APP_ID = "100009111";
    private static final String ADS_SECRET_KEY = "fe4763a347b8251bcdd397c41fc4c2d4";
    private static final String TAG_LIST = "2cbd09d1a76ca8c281f521a35f93b94b";
    private static final String TAG_INTERSTITIAL_FULLSCREEN = "69fb56d4913fa354ec240e30c244d459";
    private static final String TAG_INTERSTITIAL_WIDGET = "9cd6d1c3d58218e9d7fe09c7b6cb4029";
    private static final String TAG_BANNER = "e38db04af414b6d45af6b5488d043dbc";

    static private RelativeLayout mContentView;
    static private LinearLayout mBannerLayout;
    static private LinearLayout mWidgetLayout;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        s_instance = this;

        mContentView = new RelativeLayout(this);
        LayoutParams lp = new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.FILL_PARENT);
        s_instance.addContentView(mContentView,lp);

        mBannerLayout = new LinearLayout(this);
        int h = dip2px(this,60);
        LayoutParams lpb = new LayoutParams(LayoutParams.WRAP_CONTENT,h);
        mContentView.addView(mBannerLayout,lpb);
        mBannerLayout.setVisibility(View.GONE);

        mWidgetLayout = new LinearLayout(this);
        h = dip2px(this,180);
        LayoutParams lpw = new LayoutParams(LayoutParams.WRAP_CONTENT,h);
        mContentView.addView(mWidgetLayout,lpw);

        try {
            Ads.init(this, ADS_APP_ID, ADS_SECRET_KEY);
        } catch (Exception e) {
            e.printStackTrace();
        }
        Ads.preLoad(this, Fetcher.AdFormat.appwall, TAG_LIST);
        Ads.preLoad(this, Fetcher.AdFormat.interstitial,TAG_INTERSTITIAL_FULLSCREEN);
        Ads.preLoad(this, Fetcher.AdFormat.interstitial,TAG_INTERSTITIAL_WIDGET);

        mBannerLayout.addView(Ads.showBannerAd(s_instance, null, TAG_BANNER));
    }

    public static void showAdsAppWall() {
        Ads.showAppWall(s_instance, TAG_LIST);
    }

    public static void showAdsFull(final String html) {
        s_instance.runOnUiThread(new Runnable() {
            public void run() {
                final Dialog dialog = new Dialog(s_instance,R.style.NoBoundDialog);
                LinearLayout layout = new LinearLayout(s_instance);
                layout.setOrientation(LinearLayout.VERTICAL);

                View adsView = Ads.showAppWidget(s_instance, null, TAG_INTERSTITIAL_FULLSCREEN, Ads.ShowMode.WIDGET);

                ImageButton btn = (ImageButton)adsView.findViewById(R.id.app_widget_close_button);
                btn.setOnClickListener(new OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        dialog.dismiss();
                    }
                });
                layout.addView(adsView);

                TextView tv = new TextView(s_instance);
                tv.setText(Html.fromHtml(html));
                tv.setPadding(16,0,16,0);
                layout.addView(tv);

                LayoutParams lytp = new LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
                dialog.setContentView(layout,lytp);
                dialog.show();
            }
        });
    }

    public static void closeAdsWidget() {
        s_instance.runOnUiThread(new Runnable() {
            public void run() {
                mWidgetLayout.removeAllViews();
            }
        });
    }
    // bottom
    public static void showAdsWidget() {
        s_instance.runOnUiThread(new Runnable() {
            public void run() {
                View adsView = Ads.showAppWidget(s_instance, null, TAG_INTERSTITIAL_WIDGET, Ads.ShowMode.WIDGET);
                ImageButton btn = (ImageButton)adsView.findViewById(R.id.app_widget_close_button);
                btn.setOnClickListener(new OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        mWidgetLayout.removeAllViews();
                    }
                });
                mWidgetLayout.addView(adsView);
            }
        });
    }

    public static int dip2px(Context context, float dipValue){   
        final float scale = context.getResources().getDisplayMetrics().density;   
        return (int)(dipValue * scale + 0.5f);   
    } 

    public static void closeAdsBanner() {
        s_instance.runOnUiThread(new Runnable() {
            public void run() {
                mBannerLayout.setVisibility(View.GONE);
            }
        });
    }
    public static void showAdsBanner() {
        s_instance.runOnUiThread(new Runnable() {
            public void run() {
                mBannerLayout.setVisibility(View.VISIBLE);
            }
        });
    }
    public static void share(final String title, final String txt, final String imgName, final String dialogTitle) {
        s_instance.runOnUiThread(new Runnable() {
            public void run() {
                String fname = "/data/data/"+s_instance.getApplicationInfo().packageName+"/files/"+imgName;
                try {
                    Runtime.getRuntime().exec("chmod 777 " + fname);
                } catch (Exception e) {}
                String filePath = "file:///"+fname;
                Intent intent = new Intent("android.intent.action.SEND");
                intent.setType("image/*");
                intent.putExtra(Intent.EXTRA_SUBJECT, title);
                intent.putExtra(Intent.EXTRA_TEXT, txt);
                intent.putExtra(Intent.EXTRA_STREAM,Uri.parse(filePath));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                s_instance.startActivity(Intent.createChooser(intent, dialogTitle));
            }
        });
    }
    public static boolean isNetConnect() {
        try {
            ConnectivityManager connectivity = (ConnectivityManager)s_instance.getSystemService(Context.CONNECTIVITY_SERVICE);
            if (connectivity != null) {
                NetworkInfo info = connectivity.getActiveNetworkInfo();
                if (info != null&& info.isConnected()) {
                    if (info.getState() == NetworkInfo.State.CONNECTED) {
                        return true;
                    }
                }
            }
        } catch (Exception e) {
        }
        return false;
    }

}
