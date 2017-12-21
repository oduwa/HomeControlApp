package com.odie.rachelslights.colorbox;

import android.app.Activity;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import com.odie.rachelslights.R;

class ColorsAdapter extends RecyclerView.Adapter<ColorsAdapter.SimpleViewHolder> {

    private Pair<String[], String[]> mColors;
    private Activity mActivity;

    //simple recycler view adapter with activity and array list contact as arguments
    ColorsAdapter(Activity activity, Pair<String[], String[]> colors) {
        mActivity = activity;
        mColors = colors;
    }

    @Override
    public SimpleViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        // inflate recycler view items layout
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.color_item, parent, false);

        return new SimpleViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(SimpleViewHolder holder, int position) {

        holder.code.setText(mColors.first[holder.getAdapterPosition()]);
        holder.hex.setText(mColors.second[holder.getAdapterPosition()]);

        int color = Color.parseColor(mColors.second[holder.getAdapterPosition()]);

        int textColor = ColorBox.isColorDark(color) ? Color.WHITE : Color.BLACK;

        holder.code.setTextColor(textColor);
        holder.hex.setTextColor(textColor);

        holder.itemView.setBackgroundColor(color);
    }

    @Override
    public int getItemCount() {

        //get array length
        return mColors.first.length;
    }

    //simple view holder implementing click
    class SimpleViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        TextView code, hex;

        SimpleViewHolder(View itemView) {
            super(itemView);

            code = (TextView) itemView.findViewById(R.id.code);
            hex = (TextView) itemView.findViewById(R.id.hex);

            //enable click and on long click
            itemView.setOnClickListener(this);
        }

        //add click
        @Override
        public void onClick(View v) {

            ColorBox.setColor(mActivity, Color.parseColor(mColors.second[getAdapterPosition()]));
        }
    }
}
