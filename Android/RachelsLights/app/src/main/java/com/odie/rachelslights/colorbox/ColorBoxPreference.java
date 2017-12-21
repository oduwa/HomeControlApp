package com.odie.rachelslights.colorbox;

import android.content.Context;
import android.preference.Preference;
import android.util.AttributeSet;
import android.view.View;

import com.odie.rachelslights.R;

public class ColorBoxPreference extends Preference {

    private Context mContext;
    private int mSelectedColor;

    public ColorBoxPreference(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    private ColorBoxPreference(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        mContext = context;
        mSelectedColor = ColorBox.getColor(getKey(), mContext);
        setSummary(ColorBox.getHexadecimal(mSelectedColor).toUpperCase());
        setLayoutResource(R.layout.preference);
    }

    @Override
    protected void onBindView(View view) {
        super.onBindView(view);

        view.findViewById(R.id.icon).setBackground(Utils.round(mContext.getResources(), false, android.R.dimen.app_icon_size, mSelectedColor));
    }

    @Override
    protected void onClick() {
        super.onClick();
        ColorBox.showColorBoxPreference(getKey(), mContext);
    }
}
