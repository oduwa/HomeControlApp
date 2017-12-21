package com.odie.rachelslights.colorbox;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import com.odie.rachelslights.R;

public class PalettesFragment extends Fragment {

    private RecyclerView mColorsRV;
    private Activity mActivity;
    private View mPaletteView;

    @Override
    public void onResume() {
        super.onResume();
        SelectorsAdapter.mSelectedColor = Color.parseColor(Palettes.getPalette(Palettes.RED, true).second[6]);
    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        return inflater.inflate(
                R.layout.palette_fragment, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {

        mActivity = getActivity();

        mPaletteView = view;

        mColorsRV = (RecyclerView) view.findViewById(R.id.colors);

        setSelectorsRV();

        setColorsRV(Palettes.getPalette(Palettes.RED, true));

        setBoxToolbar();
    }

    void setSelectorsRV() {

        RecyclerView selectorsRV = (RecyclerView) mPaletteView.findViewById(R.id.selectors);

        LinearLayoutManager selectorsLayoutManager = new LinearLayoutManager(mActivity, LinearLayoutManager.VERTICAL, false);

        selectorsRV.addItemDecoration(new ItemOffsetDecoration(mActivity, R.dimen.selectors_offset));
        selectorsRV.setLayoutManager(selectorsLayoutManager);

        SelectorsAdapter selectorsAdapter = new SelectorsAdapter(mActivity, mPaletteView);

        selectorsRV.setAdapter(selectorsAdapter);
    }

    void setColorsRV(Pair<String[], String[]> colors) {

        LinearLayoutManager colorsLayoutManager = new LinearLayoutManager(mActivity, LinearLayoutManager.VERTICAL, false);

        mColorsRV.addItemDecoration(new ItemOffsetDecoration(mActivity, R.dimen.colors_offset));
        mColorsRV.setLayoutManager(colorsLayoutManager);

        ColorsAdapter colorsAdapter = new ColorsAdapter(mActivity, colors);

        mColorsRV.setAdapter(colorsAdapter);
    }

    void setBoxToolbar() {

        int defaultColor = Color.parseColor(Palettes.getPalette(Palettes.RED, true).second[6]);

        mPaletteView.findViewById(R.id.box_toolbar).setBackgroundColor(defaultColor);

        TextView boxTitle = (TextView) mPaletteView.findViewById(R.id.box_title);
        boxTitle.setText(getString(R.string.red));
    }
}
