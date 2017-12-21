package com.odie.rachelslights.colorbox;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.support.v4.graphics.drawable.RoundedBitmapDrawable;
import android.support.v4.graphics.drawable.RoundedBitmapDrawableFactory;
import android.view.View;
import android.widget.SeekBar;

import java.util.HashMap;
import java.util.Map;
import com.odie.rachelslights.R;

class Utils {

    //create rounded bitmap drawable
    static RoundedBitmapDrawable round(Resources resources, boolean isLand, int dim, int color) {

        Bitmap.Config conf = Bitmap.Config.ARGB_8888;

        int dimen = isLand ? Math.round((int) resources.getDimension(dim) * 0.85f) : (int) resources.getDimension(dim);

        Bitmap bitmap = Bitmap.createBitmap(dimen, dimen, conf);

        bitmap.eraseColor(color);

        // Create a new RoundedBitmapDrawable
        RoundedBitmapDrawable roundedBitmapDrawable = RoundedBitmapDrawableFactory.create(resources, bitmap);

        roundedBitmapDrawable.setCircular(true);

        roundedBitmapDrawable.setAntiAlias(true);

        // Return the RoundedBitmapDrawable
        return roundedBitmapDrawable;
    }

    static Map<String, String> decodeColorName(Context context) {

        Map<String, String> stringHashMap = new HashMap<>();
        stringHashMap.put(Palettes.RED, context.getString(R.string.red));
        stringHashMap.put(Palettes.PINK, context.getString(R.string.pink));
        stringHashMap.put(Palettes.PURPLE, context.getString(R.string.purple));
        stringHashMap.put(Palettes.DEEP_PURPLE, context.getString(R.string.deep_purple));
        stringHashMap.put(Palettes.INDIGO, context.getString(R.string.indigo));
        stringHashMap.put(Palettes.BLUE, context.getString(R.string.blue));
        stringHashMap.put(Palettes.LIGHT_BLUE, context.getString(R.string.light_blue));
        stringHashMap.put(Palettes.CYAN, context.getString(R.string.cyan));
        stringHashMap.put(Palettes.TEAL, context.getString(R.string.teal));
        stringHashMap.put(Palettes.GREEN, context.getString(R.string.green));
        stringHashMap.put(Palettes.LIGHT_GREEN, context.getString(R.string.light_green));
        stringHashMap.put(Palettes.LIME, context.getString(R.string.lime));
        stringHashMap.put(Palettes.YELLOW, context.getString(R.string.yellow));
        stringHashMap.put(Palettes.AMBER, context.getString(R.string.amber));
        stringHashMap.put(Palettes.ORANGE, context.getString(R.string.orange));
        stringHashMap.put(Palettes.DEEP_ORANGE, context.getString(R.string.deep_orange));
        stringHashMap.put(Palettes.BROWN, context.getString(R.string.brown));
        stringHashMap.put(Palettes.GREY, context.getString(R.string.grey));
        stringHashMap.put(Palettes.BLUE_GREY, context.getString(R.string.blue_grey));

        return stringHashMap;
    }

    //Init SeekBars color
    static void initSeekBarsColor(SeekBar... seekBars) {

        for (SeekBar seekBar : seekBars) {

            final String tag = seekBar.getTag().toString();
            final int color = Color.parseColor(tag);

            seekBar.getProgressDrawable().setColorFilter(color, PorterDuff.Mode.SRC_IN);
            seekBar.getThumb().setColorFilter(color, PorterDuff.Mode.SRC_IN);
        }
    }

    //Init SeekBars listener
    static void initSeekBars(final Activity activity, final View previewView, final SeekBar alphaSeekBar, final SeekBar RSeekBar, final SeekBar GSeekBar, final SeekBar BSeekBar) {

        alphaSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {

                ColorPickerFragment.updatePreview(activity, false, null, previewView, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });


        RSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {

                ColorPickerFragment.updatePreview(activity, false, null, previewView, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        GSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {

                ColorPickerFragment.updatePreview(activity, false, null, previewView, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        BSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {
                ColorPickerFragment.updatePreview(activity, false, null, previewView, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });
    }

    static void setBarsColor(Activity activity, int color) {
        activity.getWindow().setStatusBarColor(color);
        activity.getWindow().setNavigationBarColor(color);
    }
}
