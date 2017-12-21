package com.odie.rachelslights.colorbox;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import com.odie.rachelslights.R;

class ScreenSlidePagerAdapter extends FragmentStatePagerAdapter {

    private final static int NUM_ITEMS = 2;

    ScreenSlidePagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int position) {

        switch (position) {
            default:
            case 0:
                return new ColorPickerFragment();
            case 1:
                return new PalettesFragment();
        }
    }

    @Override
    public int getCount() {
        return NUM_ITEMS;
    }
}