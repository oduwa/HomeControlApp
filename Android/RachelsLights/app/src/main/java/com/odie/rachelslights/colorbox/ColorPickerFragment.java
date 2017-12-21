package com.odie.rachelslights.colorbox;

import android.app.Activity;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageButton;
import android.widget.SeekBar;

import com.odie.rachelslights.R;

import java.util.Set;

public class ColorPickerFragment extends Fragment {

    private Activity mActivity;
    private View mPreviewView, mLatestToolbar;
    private SeekBar mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar;
    private RecyclerView mLatestRV;
    private Set<String> mLatestStringSet;

    static void resetPicker(Activity activity, View previewView, SeekBar... seekBars) {

        for (SeekBar seekBar : seekBars) {
            seekBar.setProgress(255);
        }
        previewView.setBackground(Utils.round(activity.getResources(), isLand(activity.getResources()), android.R.dimen.thumbnail_height, Color.WHITE));
    }

    private static int getColorARGB(int which, SeekBar alphaSeekBar, SeekBar RSeekBar, SeekBar GSeekBar, SeekBar BSeekBar) {

        final int A = alphaSeekBar.getProgress();
        final int R = RSeekBar.getProgress();
        final int G = GSeekBar.getProgress();
        final int B = BSeekBar.getProgress();

        int returned = A;

        switch (which) {

            case 1:
                returned = R;
                break;

            case 2:
                returned = G;
                break;
            case 3:
                returned = B;
                break;

            case 4:
                returned = Color.argb(A, R, G, B);
        }

        return returned;
    }

    static void updatePreview(final Activity activity, final boolean isOnCreate, final Integer fromLatest, final View previewView, final SeekBar alphaSeekBar, final SeekBar RSeekBar, final SeekBar GSeekBar, final SeekBar BSeekBar) {

        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {

                int A = getColorARGB(0, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);
                int R = getColorARGB(1, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);
                int G = getColorARGB(2, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);
                int B = getColorARGB(3, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);

                int ARGB = getColorARGB(4, alphaSeekBar, RSeekBar, GSeekBar, BSeekBar);

                if (isOnCreate) {

                    int savedColor = fromLatest != null ? fromLatest : ColorBox.getColor(ColorBox.getTag(), activity);
                    A = Color.alpha(savedColor);
                    R = Color.red(savedColor);
                    G = Color.green(savedColor);
                    B = Color.blue(savedColor);
                    ARGB = savedColor;
                }

                alphaSeekBar.setProgress(A);
                RSeekBar.setProgress(R);
                GSeekBar.setProgress(G);
                BSeekBar.setProgress(B);

                previewView.setBackground(Utils.round(activity.getResources(), isLand(activity.getResources()), android.R.dimen.thumbnail_height, ARGB));

            }
        });
    }

    private static boolean isLand(Resources resources) {
        return getScreenOrientation(resources) == Configuration.ORIENTATION_LANDSCAPE;
    }

    private static int getScreenOrientation(Resources resources) {
        return resources.getConfiguration().orientation;
    }

    void resetLatest() {

        ColorBox.deleteLatest(getActivity());

        mLatestRV.setVisibility(View.GONE);
        mLatestToolbar.setVisibility(View.GONE);
    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        return inflater.inflate(
                R.layout.picker_fragment, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {

        mActivity = getActivity();

        mLatestStringSet = ColorBox.getLatest(mActivity);

        Utils.setBarsColor(mActivity, Color.DKGRAY);

        mPreviewView = view.findViewById(R.id.preview);

        mLatestToolbar = view.findViewById(R.id.latest_bar);
        mLatestRV = (RecyclerView) view.findViewById(R.id.latest_rv);

        mAlphaSeekBar = (SeekBar) view.findViewById(R.id.alpha);
        mRSeekBar = (SeekBar) view.findViewById(R.id.r);
        mGSeekBar = (SeekBar) view.findViewById(R.id.g);
        mBSeekBar = (SeekBar) view.findViewById(R.id.b);

        Utils.initSeekBarsColor(mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar);
        Utils.initSeekBars(mActivity, mPreviewView, mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar);
        updatePreview(mActivity, true, null, mPreviewView, mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar);

        ImageButton saveButton = (ImageButton) view.findViewById(R.id.save);

        saveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                int ARGB = getColorARGB(4, mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar);
                ColorBox.setColor(mActivity, ARGB);
                ColorBox.saveToLatest(mActivity, ARGB);
            }
        });

        final ImageButton resetButton = (ImageButton) view.findViewById(R.id.reset);

        resetButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Animation startRotateAnimation = AnimationUtils.loadAnimation(mActivity, R.anim.rotate);
                startRotateAnimation.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationStart(Animation animation) {

                    }

                    @Override
                    public void onAnimationEnd(Animation animation) {
                        resetPicker(mActivity, mPreviewView, mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar);
                    }

                    @Override
                    public void onAnimationRepeat(Animation animation) {

                    }
                });
                resetButton.startAnimation(startRotateAnimation);
            }
        });

        if (mLatestStringSet != null && !mLatestStringSet.isEmpty()) {

            setupLatestRV();

            mLatestToolbar.setVisibility(View.VISIBLE);
            mLatestRV.setVisibility(View.VISIBLE);

            ImageButton resetLast = (ImageButton) view.findViewById(R.id.clear);

            resetLast.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    resetLatest();
                }
            });
        }
    }

    private void setupLatestRV() {

        mLatestRV.addItemDecoration(new ItemOffsetDecoration(mActivity, R.dimen.colors_offset));

        GridLayoutManager latestLayoutManager;

        if (getScreenOrientation(mActivity.getResources()) == Configuration.ORIENTATION_LANDSCAPE) {

            latestLayoutManager = new GridLayoutManager(mActivity, 12);

            mLatestRV.setLayoutManager(latestLayoutManager);

        } else {

            latestLayoutManager = new GridLayoutManager(mActivity, 6);

            mLatestRV.setLayoutManager(latestLayoutManager);
        }

        LatestAdapter latestAdapter = new LatestAdapter(mActivity, mLatestStringSet, mPreviewView, mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar);

        mLatestRV.setAdapter(latestAdapter);
    }
}
