package com.odie.rachelslights.colorbox;

import android.app.Activity;
import android.graphics.Color;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import com.odie.rachelslights.R;

class SelectorsAdapter extends RecyclerView.Adapter<SelectorsAdapter.SimpleViewHolder> {

    static Integer mSelectedColor;
    private Activity mActivity;
    private View mPaletteView;

    SelectorsAdapter(Activity activity, View paletteView) {

        mActivity = activity;
        mPaletteView = paletteView;
    }

    static Integer getSelectorColor() {
        return mSelectedColor;
    }

    @Override
    public SimpleViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        // inflate recycler view items layout
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.selector_item, parent, false);

        return new SimpleViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(SimpleViewHolder holder, int position) {
        holder.selector.setBackground(Utils.round(mActivity.getResources(), false, android.R.dimen.app_icon_size, Color.parseColor(Palettes.getSelectorColors()[holder.getAdapterPosition()])));
    }

    @Override
    public int getItemCount() {

        //get array length
        return Palettes.colorsStrings.length;
    }

    //simple view holder implementing click listener
    class SimpleViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        ImageView selector;

        SimpleViewHolder(View itemView) {
            super(itemView);

            selector = (ImageView) itemView.findViewById(R.id.selector);

            //enable click
            itemView.setOnClickListener(this);
        }

        private void updateColors() {

            RecyclerView colorsRV = (RecyclerView) mPaletteView.findViewById(R.id.colors);
            View boxToolbar = mPaletteView.findViewById(R.id.box_toolbar);

            LinearLayoutManager colorsLayoutManager = new LinearLayoutManager(mActivity, LinearLayoutManager.VERTICAL, false);

            colorsRV.setLayoutManager(colorsLayoutManager);

            Boolean codesNormal = getAdapterPosition() <= Palettes.colorsStrings.length - 6;

            ColorsAdapter colorsAdapter = new ColorsAdapter(mActivity, Palettes.getPalette(Palettes.colorsStrings[getAdapterPosition()], codesNormal));

            colorsRV.setAdapter(colorsAdapter);

            mSelectedColor = Color.parseColor(Palettes.getPalette(Palettes.colorsStrings[getAdapterPosition()], codesNormal).second[6]);

            boxToolbar.setBackgroundColor(mSelectedColor);

            TextView boxTitle = (TextView) mActivity.findViewById(R.id.box_title);
            boxTitle.setText(Utils.decodeColorName(mActivity).get(Palettes.colorsStrings[getAdapterPosition()]));

            Utils.setBarsColor(mActivity, mSelectedColor);
        }

        //add click
        @Override
        public void onClick(View v) {

            if (getAdapterPosition() <= Palettes.colorsStrings.length - 3) {

                updateColors();

            } else {

                int selectorColor = Color.parseColor(Palettes.getPalette(Palettes.colorsStrings[getAdapterPosition()], false).second[0]);

                ColorBox.setColor(mActivity, selectorColor);

                mActivity.finish();
            }
        }
    }
}
