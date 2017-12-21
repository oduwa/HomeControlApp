package com.odie.rachelslights.colorbox;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;

import com.odie.rachelslights.R;

public class ColorBoxActivity extends FragmentActivity {

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setTheme(R.style.ColorBoxTheme);
        setContentView(R.layout.box_activity);

        ViewPager pager = (ViewPager) findViewById(R.id.viewpager);
        pager.setPageTransformer(true, new ZoomOutPageTransformer());
        PagerAdapter pagerAdapter = new ScreenSlidePagerAdapter(getSupportFragmentManager());
        pager.setAdapter(pagerAdapter);

        pager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {

                switch (position) {
                    case 0:
                        Utils.setBarsColor(ColorBoxActivity.this, Color.DKGRAY);
                        break;
                    case 1:
                        int color = SelectorsAdapter.getSelectorColor() != null ? SelectorsAdapter.getSelectorColor() : Color.parseColor(Palettes.getPalette(Palettes.RED, true).second[6]);
                        Utils.setBarsColor(ColorBoxActivity.this, color);
                        break;
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    public void closeBox(View v) {
        finishAndRemoveTask();
    }
}
