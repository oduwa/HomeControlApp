package com.odie.rachelslights.colorbox;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.SeekBar;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import com.odie.rachelslights.R;

class LatestAdapter extends RecyclerView.Adapter<LatestAdapter.SimpleViewHolder> {

    private Activity mActivity;
    private List<String> mLatestListString;
    private View mPreviewView;
    private SeekBar mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar;

    LatestAdapter(Activity activity, Set<String> latestStringSet, View previewView, SeekBar alphaSeekBar, SeekBar RSeekBar, SeekBar GSeekBar, SeekBar BSeekBar) {

        mPreviewView = previewView;
        mAlphaSeekBar = alphaSeekBar;
        mRSeekBar = RSeekBar;
        mGSeekBar = GSeekBar;
        mBSeekBar = BSeekBar;

        mLatestListString = new ArrayList<>();

        if (latestStringSet != null) {
            mLatestListString.addAll(latestStringSet);
        }
        mActivity = activity;
    }

    @Override
    public SimpleViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        // inflate recycler view items layout
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.latest_item, parent, false);

        return new SimpleViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(SimpleViewHolder holder, int position) {
        holder.latest.setBackground(Utils.round(mActivity.getResources(), false, android.R.dimen.app_icon_size, Integer.valueOf(mLatestListString.get(holder.getAdapterPosition()))));
    }

    @Override
    public int getItemCount() {

        //get array length
        return mLatestListString.size();
    }

    //simple view holder implementing click listener
    class SimpleViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        ImageView latest;

        SimpleViewHolder(View itemView) {
            super(itemView);

            latest = (ImageView) itemView.findViewById(R.id.latest_item);

            //enable click
            itemView.setOnClickListener(this);
        }

        //add click
        @Override
        public void onClick(View v) {
            ColorPickerFragment.updatePreview(mActivity, true, Integer.valueOf(mLatestListString.get(getAdapterPosition())), mPreviewView, mAlphaSeekBar, mRSeekBar, mGSeekBar, mBSeekBar);
        }
    }
}
